#
# Cookbook:: forge_server
# Recipe:: auto_restart
#
# Copyright:: 2016, Stefan Wendler
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'forge_server::default'

init_script = ::File.join node['forge_server']['rc_d']['dir'], node['forge_server']['rc_d']['name']
cron_time = node['forge_server']['auto_restart']['time']

# We use onestop and onestart here since this might be enabled, even if the service isn't.
cron 'forgeserver_auto_restart' do
  command "#{init_script} onestop ; sleep 5 ; #{init_script} onestart"
  weekday cron_time[:weekday]
  month cron_time[:month]
  day cron_time[:day]
  hour cron_time[:hour]
  minute cron_time[:minute]
  time cron_time[:time]
  path '/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/root/bin'
  user 'root'
  shell '/bin/csh'
  action (node['forge_server']['auto_restart']['enable'])? :create : :delete
end
