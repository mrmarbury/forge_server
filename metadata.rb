name 'forge_server'
maintainer 'Stefan Wendler'
maintainer_email 'stefan@binarysun.de'
license 'Apache-2.0'
description 'Installs/Configures a Forge Server on FreeBSD'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://github.com/mrmarbury/forge_server/issues' if respond_to?(:issues_url)
source_url 'https://github.com/mrmarbury/forge_server' if respond_to?(:source_url)

version '1.2.0'

supports 'freebsd', '>= 10.3'
chef_version '>= 12'

depends 'poise-archive', '~> 1.5.0'
depends 'apache2', '~> 5.0.1'
