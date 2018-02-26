default['forge_server']['openjdk_version'] = 8
default['forge_server']['system_packages'] = %W( openjdk#{node['forge_server']['openjdk_version']} tmux curl bash)

default['forge_server']['install_base'] = 'Server'
default['forge_server']['addon_dir'] = '.Addon'

default['forge_server']['rc_d']['name'] = 'forge_server'
default['forge_server']['rc_d']['dir'] = '/usr/local/etc/rc.d'

default['forge_server']['user']['name'] = 'forge'
default['forge_server']['user']['group'] = 'forge'
default['forge_server']['user']['shell'] = '/bin/sh'
default['forge_server']['user']['home'] = '/usr/local/forge'

# Every file in this array will be symlinked to the FTB dir
default['forge_server']['addon_config']['files'] = %w( whitelist.json ops.json banned-ips.json banned-players.json )

## We have to accept the Minecraft eula to be able to start the FTB Server
default['forge_server']['eula']['do_accept'] = true

default['forge_server']['settings_local_sh']['java_cmd'] = 'java'
default['forge_server']['settings_local_sh']['xms'] = '2G'
default['forge_server']['settings_local_sh']['xmx'] = '8G'
default['forge_server']['settings_local_sh']['permgen_size'] = '256M'
default['forge_server']['settings_local_sh']['java_parameters'] = %w(
                                                                    -XX:+UseParNewGC
                                                                    -XX:+CMSIncrementalPacing
                                                                    -XX:+CMSClassUnloadingEnabled
                                                                    -XX:ParallelGCThreads=2
                                                                    -XX:MinHeapFreeRatio=5
                                                                    -XX:MaxHeapFreeRatio=10
                                                                  )
# if false, the server might not start because of changed blocks during version upgrade
# you may leave this false but then you have to connect to the server console and /fml confirm manually
default['forge_server']['fml']['add_confirm_option'] = true
default['forge_server']['fml']['confirm_option'] = '-Dmfl.queryResult=confirm'

default['forge_server']['server_properties']['spawn_protection'] = 16
default['forge_server']['server_properties']['max_tick_time'] = 60000
default['forge_server']['server_properties']['generator_settings'] = ''
default['forge_server']['server_properties']['force_gamemode'] = true
default['forge_server']['server_properties']['allow_nether'] = true
default['forge_server']['server_properties']['gamemode'] = 0
default['forge_server']['server_properties']['broadcast_console_to_ops'] = true
default['forge_server']['server_properties']['enable_query'] = false
default['forge_server']['server_properties']['player_idle_timeout'] = 0
default['forge_server']['server_properties']['difficulty'] = 1
default['forge_server']['server_properties']['spawn_monsters'] = true
default['forge_server']['server_properties']['op_permission_level'] = 4
default['forge_server']['server_properties']['announce_player_achievements'] = true
default['forge_server']['server_properties']['pvp'] = true
default['forge_server']['server_properties']['snooper_enabled'] = true
default['forge_server']['server_properties']['level_type'] = 'BIOMESOP'
default['forge_server']['server_properties']['hardcore'] = false
default['forge_server']['server_properties']['enable_command_block'] = false
default['forge_server']['server_properties']['max_players'] = 20
default['forge_server']['server_properties']['network_compression_threshold'] = 256
default['forge_server']['server_properties']['max_world_size'] = 29999984
default['forge_server']['server_properties']['server_port'] = 25565
default['forge_server']['server_properties']['texture_pack'] = ''
default['forge_server']['server_properties']['server_ip'] = node['ipaddress']
default['forge_server']['server_properties']['spawn_npcs'] = true
default['forge_server']['server_properties']['allow_flight'] = true
default['forge_server']['server_properties']['level_name'] = 'MyWorld'
default['forge_server']['server_properties']['view_distance'] = 12
default['forge_server']['server_properties']['spawn_animals'] = true
default['forge_server']['server_properties']['white_list'] = true
default['forge_server']['server_properties']['generate_structures'] = true
default['forge_server']['server_properties']['online_mode'] = true
default['forge_server']['server_properties']['max_build_height'] = 256
default['forge_server']['server_properties']['level_seed'] = '2323115871908605002'
# Minecraft will escape characters like !, =, :, etc so we might as well escape them here to prevent rewrite of the config with every chef run
default['forge_server']['server_properties']['motd'] = 'Be nice to each other\! NO griefing\!\!'
default['forge_server']['server_properties']['resource_pack_url'] = 'https\://media.forgecdn.net/files/2440/454/Unity-1.5.0.zip'
##
default['forge_server']['server_properties']['resource_pack_sha1hash'] = 'dffe727b4a0b51e35565e334269fb8080e3691cf'
default['forge_server']['server_properties']['enable_rcon'] = false
## other options for server.properties, like {'my-property' => 'value', ...}
default['forge_server']['server_properties']['additional_options'] = {}

## example: http://files.minecraftforge.net/maven/net/minecraftforge/forge/1.12.2-14.23.2.2611/forge-1.12.2-14.23.2.2611-installer.jar
default['forge_server']['installer']['base_url'] = 'http://files.minecraftforge.net/maven/net/minecraftforge/forge'
## in the form '1.12.2-14.23.2.2611'
default['forge_server']['installer']['version'] = nil
default['forge_server']['installer']['options'] = '--installServer nogui'

# This is a self-chosen name. Could be anything and is here to distinguish different Minecraft installations
default['forge_server']['name'] = 'ModdedMinecraft'

default['forge_server']['start_server'] = true

## Set by Cookbook. Do NOT edit!
default['forge_server']['installed']['forge_version'] = nil

## Don't change these attributes!
default['forge_server']['base_dir'] = ::File.join node['forge_server']['user']['home'], node['forge_server']['name']
default['forge_server']['addon_dir'] = ::File.join node['forge_server']['base_dir'], node['forge_server']['addon_dir']
