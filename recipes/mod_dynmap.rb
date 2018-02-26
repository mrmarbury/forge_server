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

install_base = node['forge_server']['install_base']

pack_base_dir = node['forge_server']['pack_base_dir']
pack_version = node['forge_server']['pack']['version']
pack_version_dir = "#{install_base}.#{pack_version}"
pack_version_server_dir = ::File.join pack_base_dir, pack_version_dir
pack_addon_dir = node['forge_server']['pack_addon_dir']

pack_version = node['forge_server']['pack']['version']
pack_name = node['forge_server']['pack']['name']

mods_dir = ::File.join pack_version_server_dir, 'mods'
forge_group = node['forge_server']['user']['group']
forge_user = node['forge_server']['user']['name']

rc_script = node['forge_server']['rc_d']['name']

remote_file ::File.join mods_dir, 'dynmap.jar' do
  source node['forge_server']['mod_dynmap']['jar_url']
  owner forge_user
  group forge_group
  mode '0644'
  action :create
  notifies :restart, "service[#{rc_script}]", :delayed if node['forge_server']['mod_dynmap']['restart_on_update']
end

dynmap_addon_path = ::File.join pack_addon_dir, 'dynmap'

directory dynmap_addon_path do
  owner forge_user
  group forge_group
  recursive true
  mode '750'
end

link ::File.join pack_version_server_dir, 'dynmap' do
  to dynmap_addon_path
end

template ::File.join dynmap_addon_path, 'configuration.txt' do
  source 'configuration.txt.erb'
  user forge_user
  group forge_group
  mode '644'
  variables(
      webpage_title: "v" + pack_version + " - " + pack_name,
  )
end

