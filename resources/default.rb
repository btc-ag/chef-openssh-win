property :version, String, name_property: true
property :path, String, default: 'C:\Program Files'
property :add_to_path, [true, false], default: true
property :start_service, [true, false], default: true
property :startup_type, [:automatic, :disabled, :manual], default: :automatic
property :add_firewall_rule, [true, false], default: true

action :install do
  path = new_resource.path
  openssh_install_path = path + '\OpenSSH-Win64'
  short_version = new_resource.version.to_f
  source = "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v#{new_resource.version}/OpenSSH-Win64.zip"
  windows_zipfile 'Download/Extract OpenSSH' do
    path      path
    source    source
    action    :unzip
    overwrite true
    not_if { shell_out("\"#{openssh_install_path}\\ssh.exe\" -V 2>&1").stdout =~ /OpenSSH_for_Windows_#{short_version}/ }
    notifies :run, 'powershell_script[install-and-configure-OpenSSH]', :immediate
  end

  powershell_script 'install-and-configure-OpenSSH' do
    action :nothing
    code <<-EOH
        Set-Location "#{openssh_install_path}"
        .\\install-sshd.ps1
        .\\ssh-keygen.exe -A
        .\\FixHostFilePermissions.ps1 -Confirm:$false
    EOH
  end

  windows_path openssh_install_path do
    only_if { new_resource.add_to_path }
  end

  windows_firewall_rule 'SSH' do
    description 'SSH Server Firewall rule'
    local_port 22
    direction :inbound
    action :create
    only_if { new_resource.add_firewall_rule }
  end

  windows_service 'sshd' do
    action [:start]
    only_if { new_resource.start_service }
  end

  windows_service 'sshd' do
    action [:configure_startup]
    startup_type new_resource.startup_type
  end

  windows_service 'ssh-agent' do
    action [:start]
    only_if { new_resource.start_service }
  end

  windows_service 'ssh-agent' do
    action [:configure_startup]
    startup_type new_resource.startup_type
  end
end

action :remove do
  windows_firewall_rule 'SSH' do
    action :delete
  end

  path = new_resource.path
  openssh_install_path = path + '\OpenSSH-Win64'

  windows_path openssh_install_path do
    action :remove
  end
  powershell_script 'Uninstall SSHD' do
    code '.\uninstall-sshd.ps1'
    cwd openssh_install_path
    only_if { ::File.exist?("#{openssh_install_path}\\uninstall-sshd.ps1") }
  end

  directory openssh_install_path do
    action :delete
    recursive true
    retries 3
    only_if { ::File.exist?("#{openssh_install_path}\\ssh.exe") }
  end
end
