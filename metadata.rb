name 'openssh-win'
maintainer 'BTC - BU-Operations Infrastructure Group'
maintainer_email 'bop-infra@btc-ag.com'
license 'MIT'
description 'Installs/Configures openssh server on windows'
long_description 'Install or Removes OpenSSH server and client on windows'
version '1.0.2'
chef_version '>= 14.7'
supports 'windows'

depends 'windows', '~> 5.2'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/btc-ag/chef-openssh-win/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/btc-ag/chef-openssh-win'
