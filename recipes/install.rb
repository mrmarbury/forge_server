#
# Cookbook Name:: forge_server
# Recipe:: install
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
#
## Installing FTB Server
#

Chef::Resource::Execute.send(:include, Ftb::Helper)

forge_group = node['forge_server']['user']['group']
forge_user = node['forge_server']['user']['name']
forge_home = node['forge_server']['user']['home']

install_base = node['forge_server']['install_base']

pack_name = node['forge_server']['pack']['name']

pack_base_dir = node['forge_server']['pack_base_dir']
pack_addon_dir = node['forge_server']['pack_addon_dir']

pack_version = node['forge_server']['pack']['version']
pack_version_dir = "#{install_base}.#{pack_version}"

pack_version_server_dir = ::File.join pack_base_dir, pack_version_dir
pack_server_link_dir = ::File.join pack_base_dir, install_base

level_name = node['forge_server']['server_properties']['level_name']

rc_script = node['forge_server']['rc_d']['name']
init_script = ::File.join node['forge_server']['rc_d']['dir'], rc_script

## These resources will be executed at compile time. So in a wrapper-Cookbook .Addon is present when needed
group forge_group do
  action :nothing
end.run_action :create

user forge_user do
  group forge_group
  home forge_home
  manage_home true
  shell node['forge_server']['user']['shell']
  action :nothing
end.run_action :create

[pack_base_dir, pack_version_server_dir, pack_addon_dir].each do |pdir|
  directory pdir do
    owner forge_user
    group forge_group
    recursive true
    mode '750'
    action :nothing
  end.run_action :create
end

## END of compile time resources ##

node['forge_server']['packages'].each do |pkg|
  package pkg
end

execute 'send_stop_to_forge_server_before_pack_update' do
  command "#{init_script} stop"
  only_if { ::File.exists?(init_script) && forge_is_upgradeable(pack_version, pack_server_link_dir)}
end

template init_script do
  user 'root'
  group 'wheel'
  mode '555'
  variables(
      forge_name: rc_script,
      forge_server_home: pack_version_server_dir,
      forge_server_name: pack_name,
      forge_user: forge_user,
      forge_world_name: level_name
  )
end

# Points to the current version
link pack_server_link_dir do
  to pack_version_server_dir
end

## making sure the linkable dirs for persistent data exist and are linked to the Server dir
[node['forge_server']['server_properties']['level_name'], 'backups'].each do |addon_dir|
  pack_addon_path = ::File.join(pack_addon_dir, addon_dir)

  directory pack_addon_path do
    owner forge_user
    group forge_group
    recursive true
    mode '750'
  end

  link ::File.join(pack_version_server_dir, addon_dir) do
    to pack_addon_path
  end
end

pack_url = node['forge_server']['pack']['base_url'] + '/' +
           pack_name + '/' +
           pack_version.tr('.', '_') + '/' +
           pack_name + 'Server.zip'

poise_archive pack_url do
  destination pack_version_server_dir
  user forge_user
  group forge_group
  keep_existing true
  strip_components 0
  not_if { ::File.exists?(::File.join(pack_version_server_dir, 'ServerStart.sh')) }
end

template ::File.join pack_version_server_dir, 'eula.txt' do
  source 'eula.txt.erb'
  user forge_user
  group forge_group
  mode '644'
  variables( accept_eula: node['forge_server']['eula']['do_accept'] )
end

# Minecraft will escape characters like !, = etc in the motd so we might as well escape them here to prevent rewrite
# of the config with every chef run (see motd)
template ::File.join pack_version_server_dir, 'server.properties' do
  source 'server.properties.erb'
  user forge_user
  group forge_group
  mode '644'
  variables(
      spawn_protection: node['forge_server']['server_properties']['spawn_protection'],
      max_tick_time: node['forge_server']['server_properties']['max_tick_time'],
      generator_settings: node['forge_server']['server_properties']['generator_settings'],
      force_gamemode: node['forge_server']['server_properties']['force_gamemode'],
      allow_nether: node['forge_server']['server_properties']['allow_nether'],
      gamemode: node['forge_server']['server_properties']['gamemode'],
      broadcast_console_to_ops: node['forge_server']['server_properties']['broadcast_console_to_ops'],
      enable_query: node['forge_server']['server_properties']['enable_query'],
      player_idle_timeout: node['forge_server']['server_properties']['player_idle_timeout'],
      difficulty: node['forge_server']['server_properties']['difficulty'],
      spawn_monsters: node['forge_server']['server_properties']['spawn_monsters'],
      op_permission_level: node['forge_server']['server_properties']['op_permission_level'],
      announce_player_achievements: node['forge_server']['server_properties']['announce_player_achievements'],
      pvp: node['forge_server']['server_properties']['pvp'],
      snooper_enabled: node['forge_server']['server_properties']['snooper_enabled'],
      level_type: node['forge_server']['server_properties']['level_type'],
      hardcore: node['forge_server']['server_properties']['hardcore'],
      enable_command_block: node['forge_server']['server_properties']['enable_command_block'],
      max_players: node['forge_server']['server_properties']['max_players'],
      network_compression_threshold: node['forge_server']['server_properties']['network_compression_threshold'],
      resource_pack_sha1: node['forge_server']['server_properties']['resource_pack_sha1'],
      max_world_size: node['forge_server']['server_properties']['max_world_size'],
      server_port: node['forge_server']['server_properties']['server_port'],
      texture_pack: node['forge_server']['server_properties']['texture_pack'],
      server_ip: node['forge_server']['server_properties']['server_ip'],
      spawn_npcs: node['forge_server']['server_properties']['spawn_npcs'],
      allow_flight: node['forge_server']['server_properties']['allow_flight'],
      level_name: level_name,
      view_distance: node['forge_server']['server_properties']['view_distance'],
      resource_pack: node['forge_server']['server_properties']['resource_pack'],
      spawn_animals: node['forge_server']['server_properties']['spawn_animals'],
      white_list: node['forge_server']['server_properties']['white_list'],
      generate_structures: node['forge_server']['server_properties']['generate_structures'],
      online_mode: node['forge_server']['server_properties']['online_mode'],
      max_build_height: node['forge_server']['server_properties']['max_build_height'],
      level_seed: node['forge_server']['server_properties']['level_seed'],
      motd: "v#{pack_version} - #{pack_name} -\\=- #{node['forge_server']['server_properties']['motd']}",
      enable_rcon: node['forge_server']['server_properties']['enable_rcon'],
      additional_options: node['forge_server']['server_properties']['additional_options']
  )
end

java_parameters = case node['forge_server']['fml']['add_confirm_option']
                    when true
                      "#{node['forge_server']['settings_local_sh']['java_parameters'].join(' ')} #{node['forge_server']['fml']['confirm_option']}"
                    else
                      node['forge_server']['settings_local_sh']['java_parameters'].join ' '
                  end

template ::File.join pack_version_server_dir, 'settings-local.sh' do
  source 'settings-local.sh.erb'
  user forge_user
  group forge_group
  mode '750'
  variables(
      java_cmd: node['forge_server']['settings_local_sh']['java_cmd'],
      xms: node['forge_server']['settings_local_sh']['xms'],
      xmx: node['forge_server']['settings_local_sh']['xmx'],
      permgen_size: node['forge_server']['settings_local_sh']['permgen_size'],
      java_parameters: java_parameters
  )
end

node['forge_server']['addon_config']['files'].each do |file|
  afile = ::File.join pack_addon_dir, file
  link ::File.join pack_version_server_dir, file do
    to afile
    only_if { ::File.exists? afile }
  end
end

## Making ServerStart.sh executable
file ::File.join(pack_version_server_dir, 'ServerStart.sh') do
  mode '750'
end

service rc_script do
  supports start: true, stop: true, restart: true
  action (node['forge_server']['start_server'])? [:enable, :start] : [:disable]
end
