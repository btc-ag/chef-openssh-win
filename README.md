# OpenSSH Windows cookbook

[![Build Status](https://dev.azure.com/btcag-chef/openssh-win/_apis/build/status/btc-ag.chef-openssh-win?branchName=master)](https://dev.azure.com/btcag-chef/openssh-win/_build/latest?definitionId=1?branchName=master)

This cookbook can be used to install openssh server on windows nodes

## Simple usage

Define the variables 

```ruby
default['openssh-win']['version'] = '7.9.0.0p1-Beta' # default: 7.9.0.0p1-Beta
```

and include the `openssh-win::default` recipe. This will 
* download and unzip OpenSSH for windows to `C:\Program Files\OpenSSH-Win64`
* add it to the path, 
* Create the services for sshd and ssh-agent
* start the sshd and ssh-agent service s
* configure the sshd and ssh-agent services to start automatically
* Create a incoming firewall rule for port 22


## Usage with wrapper cookbooks

a little more control can be leveraged using the openssh_win resource block
Usage example to install openssh:

```ruby
openssh_win 'OpenSSH' do
  version '7.9.0.0p1-Beta' # only needs to be specified in recourse name is not a version
  action :install 
  path 'C:\openssh' # Optional, default is 'C:\Program Files', the subfolder OpenSSH-Win64 will always be created
  add_to_path false # Optional, default is true
  startup_type :manual # Optional, values can be :disabled, :manual or :automatic (default)
  start_service false # Optional, default is true
  add_firewall_rule false # Optional, default is true
end
```

Usage example to remove openssh:

```ruby
openssh_win '7.9.0.0p1-Beta' do
  action :remove
  path 'C:\openssh' # This must match the path that was passed during install
```