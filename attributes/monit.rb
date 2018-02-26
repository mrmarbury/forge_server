default['forge_server']['monit']['do_mailconfig'] = false
default['forge_server']['monit']['mail_server'] = 'localhost'
default['forge_server']['monit']['mail_address'] = 'ftbserver@domain.org'

## Set to nil or false to disable httpd support
default['forge_server']['monit']['http_port'] = 2812
## You might want to override these with vault values. Set Password to nil to disable authentication
default['forge_server']['monit']['http_username'] = 'ftbserver'
default['forge_server']['monit']['http_password'] = 'ftbserver'

default['forge_server']['monit']['daemon_interval'] = 60
default['forge_server']['monit']['event_slots'] = 1000
