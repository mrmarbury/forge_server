# **!!! NOT WORKING YET - Do not use or open issues for this one just yet !!!**

# forge_server

Chef Cookbook to manage a Forge-Server installation on FreeBSD.

## Requirements

### Platforms

 * FreeBSD-10.3+
 
### Chef

 * Chef-12.1+
 
### Dependent Cookbooks

 * poise_archive-1.5.0+
 * poise-monit-1.6.0+
 
## General Info On The How And Why

The Forge-Server installation is devided into three parts:

 1. The user/group and its home-dir
 2. The Modpack main directory and each version
 3. The files/directories that contain world data, backup, and config that are symlinked into each version-dir
 
An installed Forge-Server will have the following directory structure:

```
/usr/local/<user>/<pack>
                       \_ Server.A.B.C
                                     \_ installation_files/directories
                                     \_ server.properties
                                     \_ symliked files/directories from .Addon
                       \_ Server.D.E.F
                                     \_ installation_files/directories
                                     \_ server.properties
                                     \_ symliked files/directories from .Addon
                       \_ Server #symlink to current version_dir for informational purposes
                       \_ .Addon
                               \_ ops.json
                               \_ whitelist.json
                               \_ banned-ips.json
                               \_ banned-players.json
                               \_ world/
                               \_ backups/
                               \_ ...
                               
/usr/local/etc/rc.d/Forgeserver
```

The JSON-Files cannot be delivered easily as templates since they are updated through Minecraft. 
So you will have to manage them yourself in a wrapping Cookbook (or similar - see **Usage** below) and put them into the `.Addon`-directory
yourself. The Cookbook will then symlink these files to the current Server-directory. The `world`- and `backups`-directories will only
be created and then symlinked. That way the current world and backups will be available with every version within the installed pack.
For every new pack-version a new directory will be created that is called `Server.<version>` by default. And then a symlink named `Server`
will be created that points to the currently active installation. This symlink is for informational purposes only since it serves
no technical purpose in this Cookbook.

## Attributes

### General

 - `node['forge_server']['openjdk_version']` - Which OpenJDK version to install. Default: `8`
 - `node['forge_server']['packages']` - Array of packages that have to be installed prior to rolling out the Forge server. Default: `%W( openjdk#{node['forge_server']['openjdk_version']} tmux curl )`
 - `node['forge_server']['install_base']` - Base directory name for an installation. Default: `'Server'`
 - `node['forge_server']['addon_dir']` - Name of the directory that will contain all symlinked files. Default: `'.Addon'`
 - `node['forge_server']['start_server']` - Whether to enable and start the server or not. Default: `true`
 
### rc-Script

 - `node['forge_server']['rc_d']['name']` - Name of the service. Default: `'Forgeserver'`
 - `node['forge_server']['rc_d']['path']` - Path to the rc-script. Default: `'/usr/local/etc/rc.d'`

### User/Group

 - `node['forge_server']['user']['name']` - The system user. Default: `'Forge'`
 - `node['forge_server']['user']['group']` - The user's system group. Default: `'Forge'`
 - `node['forge_server']['user']['shell']` - Login shell of the system user. Default: `'/bin/sh'`
 - `node['forge_server']['user']['home']` - Home directory of the system user. This is also where the Forge installations will be made. Default: `'/usr/local/Forge'`

### Addon Config

 - `node['forge_server']['addon_config']['files']` - Array with the config files that will be symlinked to the current version's directory.
  Only files in that Array are symlinked. The reason for this is that this directory may contain other files you do not want to symlink.
  Default: `%w( whitelist.json ops.json banned-ips.json banned-players.json )`

### eula.txt-File

 - `node['forge_server']['eula']['do_accept']` - We have to accept the Minecraft eula to be able to start the Forge Server. If you set this to `false` then the server won't start. Default `true`

### settings-local.sh-File

 - `node['forge_server']['settings_local_sh']['java_cmd']` - The name of the java binary. Default: `'java'`
 - `node['forge_server']['settings_local_sh']['xms']` - The Java XMS value. Default `'2G'`
 - `node['forge_server']['settings_local_sh']['xmx']` - The Java XMX value. Default: `'8G'`
 - `node['forge_server']['settings_local_sh']['permgen_size']` - Java's PermGen Size. Default: `'256M'`
 - `node['forge_server']['settings_local_sh']['java_parameters']` - Array with Java parameters. Default: 
 
 ```
 %w(
    -XX:+UseParNewGC
    -XX:+CMSIncrementalPacing
    -XX:+CMSClassUnloadingEnabled
    -XX:ParallelGCThreads=2
    -XX:MinHeapFreeRatio=5
    -XX:MaxHeapFreeRatio=10
 )
 ```
 
### FML-Confirm

 - `node['forge_server']['fml']['add_confirm_option']` - Whether to confirm world/block-changes that might occur during server update. If this is `false` the server might not start and will wait for user interaction.
  Default: `true`
 - `node['forge_server']['fml']['confirm_option']` - The Java parameter for FML-Confirm. Default: `'-Dmfl.queryResult=confirm'`

### server.properties-File

The following attributes are the server.peoperties attributes with the same name. The attributes are not explained any further. Only the default
values and a hint will be shown next to the attribute

 - `node['forge_server']['server_properties']['spawn_protection']` - Default: `16`
 - `node['forge_server']['server_properties']['max_tick_time']` - Default: `60000`
 - `node['forge_server']['server_properties']['generator_settings']` - Default: `''`
 - `node['forge_server']['server_properties']['force_gamemode']` - Default: `true`
 - `node['forge_server']['server_properties']['allow_nether']` - Default: `true`
 - `node['forge_server']['server_properties']['gamemode']` - Default: `0`
 - `node['forge_server']['server_properties']['broadcast_console_to_ops']` - Default: `true`
 - `node['forge_server']['server_properties']['enable_query']` - Default: `false`
 - `node['forge_server']['server_properties']['player_idle_timeout']` - Default: `0`
 - `node['forge_server']['server_properties']['difficulty']` - Default: `1`
 - `node['forge_server']['server_properties']['spawn_monsters']` - Default: `true`
 - `node['forge_server']['server_properties']['op_permission_level']` - Default: `4`
 - `node['forge_server']['server_properties']['announce_player_achievements']` - Default: `true`
 - `node['forge_server']['server_properties']['pvp']` - Default: `true`
 - `node['forge_server']['server_properties']['snooper_enabled']` - Default: `true`
 - `node['forge_server']['server_properties']['level_type']` - Default: `'BIOMESOP'`
 - `node['forge_server']['server_properties']['hardcore']` - Default: `false`
 - `node['forge_server']['server_properties']['enable_command_block']` - Default: `false`
 - `node['forge_server']['server_properties']['max_players']` - Default: `20`
 - `node['forge_server']['server_properties']['network_compression_threshold']` - Default: `256`
 - `node['forge_server']['server_properties']['resource_pack_sha1']` - Default: `''`
 - `node['forge_server']['server_properties']['max_world_size']` - Default: `29999984`
 - `node['forge_server']['server_properties']['server_port']` - Default: `25565`
 - `node['forge_server']['server_properties']['texture_pack']` - Default: `''`
 - `node['forge_server']['server_properties']['server_ip']` - Default: `node['ipaddress']`
 - `node['forge_server']['server_properties']['spawn_npcs']` - Default: `true`
 - `node['forge_server']['server_properties']['allow_flight']` - Default: `true`
 - `node['forge_server']['server_properties']['level_name']` - Default: `'world'`
 - `node['forge_server']['server_properties']['view_distance']` - Default: `12`
 - `node['forge_server']['server_properties']['resource_pack']` - Default: `''`
 - `node['forge_server']['server_properties']['spawn_animals']` - Default: `true`
 - `node['forge_server']['server_properties']['white_list']` - Default: `true`
 - `node['forge_server']['server_properties']['generate_structures']` - Default: `true`
 - `node['forge_server']['server_properties']['online_mode']` - Default: `true`
 - `node['forge_server']['server_properties']['max_build_height']` - Default: `256`
 - `node['forge_server']['server_properties']['level_seed']` - Default: `'2323115871908605002'` (my favorite seed)
 - `node['forge_server']['server_properties']['motd']` - Minecraft will escape characters like !, = etc so we might as well escape them here to prevent 
 rewrite of the config with every chef run. Will get the current version and pack name prepended to it automatically. Default: `'Be nice to each other\! NO griefing\!\!'`
 - `node['forge_server']['server_properties']['enable_rcon']` - Default: `false`
 - `node['forge_server']['server_properties']['additional_options']` - Hash that can contain any other server.properties option not listed above in the form
 `{'my-property' => 'value'}`. Default: `{}`

### Pack Related

 - `node['forge_server']['pack']['base_url']` - Base URL where the Forge Server packs can be found. Default: `'http://Forge.cursecdn.com/Forge2/modpacks'`
 - `node['forge_server']['pack']['name']` - Forge modpack name. Has to be equal to the packs subdirectory on the download server. Must be set on a role/environment. Default: `nil`
 - `node['forge_server']['pack']['version']` - Version of the Forge modpack in the form `X.Y.Z`. Must be set in a role/environment. Default: `nil`

 
### mod_dynmap-Recipe

 - `node['forge_server']['mod_dynmap']['jar_url']` - URL to the Forge Version of the Dynmap jar-file. Default: `'https://addons-origin.cursecdn.com/files/2436/596/Dynmap-2.6-beta-1-forge-1.12.jar'`
 - `node['forge_server']['mod_dynmap']['restart_on_update']` - Set this to `true` to restart the server, when a new dynmap version has been installed. Default `false`
 
### auto_restart-Recipe

 - `node['forge_server']['auto_restart']['enable']` - It is a good idea to restart a Minecraft server in regular intervals. Setting this to `true` will create
  a cronjob that does exactly this. Default: `true`
 - `node['forge_server']['auto_restart']['time']` - The time at which the server gets restarted. Default: `{ minute: '0', hour: '5' }`. 
 See Chef's [cron](https://docs.chef.io/resource_cron.html) resource for more info. Possible keys are: `:weekday, :month, :day, :hour, :minute, :time`

## Usage

### Standalone

 - Add `forge_server::default` to your Nodes run list 
 - Add pack name and version to your role/environment. Role-Example:
 
 ```ruby
 override_attributes({
   "forge_server" => {
       "pack" => {
           "name" => "ForgeInfinityLite110",
           "version" => "1.3.3"
       }
   }
 })
 ```
 
### In a wrapper-cookbook with managed JSON-Files

 - Put your JSON-Files into the files-directory of your wrapper cookbook (See 'Addon Config' above for the default files that are configured in the array. Override for different files, if you know better)
 - Add the following to your wrapper Cookbooks `default.rb`

```ruby
node['forge_server']['addon_config']['files'].each do |file|
  cookbook_file ::File.join(node['forge_server']['pack_addon_dir'], file) do
    source file
    owner node['forge_server']['user']['name']
    group node['forge_server']['user']['group']
    mode '644'
  end
end

include_recipe 'forge_server::default'
```
 
 - Add pack name and version to your role/environment. Role-Example:
 
     ```ruby
     override_attributes({
       "forge_server" => {
           "pack" => {
               "name" => "ForgeInfinityLite110",
               "version" => "1.3.3"
           }
       }
     })
     ```

## Recipes

### forge_server::default

Add this recipe to your run list and set the needed attributes to get going

### forge_server::install

Gets the pack going. Included in the Default-Recipe

### forge_server::auto_restart

Creates a cronjob that restarts the server periodically, if `node['forge_server']['auto_restart']['enable']` is true

### forge_server::mod_dynmap

Installs the dynmap plugin. 

**INFO: WIP! It currently only puts the jar-file in place and triggers a restart of the server, if needed. There is no real config yet**

## How to Test

### Specs

Run command `rspec` from the root of this Cookbook

### Integration tests

**INFO: Not Yet Implementred**

 1. Install Vagrant with berkshelf and testkitchen plugins
 1. Install VirtualBox and configure it according to your OS's documentation
 1. Run `kitchen test`
 
## License and Authors

Author: Stefan Wendler (<stefan@binarysun.de>)
License: Apache License, Version 2.0 (January 2004 - http://www.apache.org/licenses/)

