#
# Cookbook:: forge_server
# Recipe:: mod_dynmap
#
# Copyright:: 2017, Stefan Wendler
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

version = node['forge_server']['installer']['version']
name = node['forge_server']['name']
addon_path = node['forge_server']['addon_dir'] + '/' + node['forge_server']['mods']['listing']['Dynmap']['server_addon_dir']

forge_group = node['forge_server']['user']['group']
forge_user = node['forge_server']['user']['name']

rc_script = node['forge_server']['rc_d']['name']

template ::File.join addon_path, 'configuration.txt' do
  source 'configuration.txt.erb'
  user forge_user
  group forge_group
  mode '644'
  variables(
      webpage_title: "v" + version + " - " + name,
      default_world: node['forge_server']['server_properties']['level_name']
  )
  notifies :restart, "service[#{rc_script}]", :delayed if node['forge_server']['mods']['restart_on_update']
end

