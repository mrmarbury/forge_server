#
# Cookbook:: forge_server
# Recipe:: mods
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

pack_base_dir = node['forge_server']['base_dir']
pack_version = node['forge_server']['installer']['version']
pack_version_dir = "#{install_base}.#{pack_version}"
pack_version_server_dir = ::File.join pack_base_dir, pack_version_dir
pack_addon_dir = node['forge_server']['addon_dir']

mods_dir = ::File.join pack_version_server_dir, 'mods'
forge_group = node['forge_server']['user']['group']
forge_user = node['forge_server']['user']['name']

rc_script = node['forge_server']['rc_d']['name']

mod_listing = node['forge_server']['mods']['listing']
curse_base_url = node['forge_server']['mods']['curse_base_url']

#  Download URL: https://<curse_base_url>/projects/<project_id>/files/<file_id>/download
mod_listing.each do |mod, config|
  if config['ignore']
    Chef::Log.warn("Skipping ignored mod #{mod}")
  else
    remote_file ::File.join mods_dir, mod + '.jar' do
      source curse_base_url + '/projects/' + config['project_id'] + '/files/' + config['file_id'] + '/download'
      owner forge_user
      group forge_group
      mode '0644'
      action :create
      notifies :restart, "service[#{rc_script}]", :delayed if node['forge_server']['mods']['restart_on_update']
    end

    if config.has_key?('server_addon_dir') && !config['server_addon_dir'].nil? && !config['server_addon_dir'].empty?

      mod_addon_dir = config['server_addon_dir']
      mod_addon_path = ::File.join pack_addon_dir, mod_addon_dir

      directory mod_addon_path do
        owner forge_user
        group forge_group
        recursive true
        mode '750'
      end

      link ::File.join pack_version_server_dir, mod_addon_dir do
        to mod_addon_path
      end
    end

    include_recipe 'forge_server::mod_' + mod.downcase if config['has_config_recipe']
  end
end
