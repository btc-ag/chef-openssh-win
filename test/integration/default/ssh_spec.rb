describe port(22) do
  it { should be_listening }
  its('processes') { should include 'sshd.exe' }
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '0.0.0.0' }
end

describe command('ssh.exe') do
  it { should exist }
end
