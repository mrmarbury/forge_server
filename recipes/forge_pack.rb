#
# Cookbook Name:: forge_server
# Recipe:: forge_pack
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
## Forge Pack Recipe
#

package 'zip'

server_name = node['forge_server']['name']
build_temp    = node['forge_server']['forge_pack']['build_temp_dir'] + '/' + server_name
overrides_subdir = "overrides/config"
overrides_build_temp_dir = build_temp + '/' + overrides_subdir

mod_listing = node['forge_server']['mods']['listing']

curse_base_url =  node['forge_server']['mods']['curse_base_url']

directory overrides_build_temp_dir do
  recursive true
end

manifest_files = []
modlist        = []
client_config_files = []

mod_listing.each do |_,data|
  if data['client']
    manifest_files.push({
      projectID: data['project_id'],
      fileID:    data['file_id'],
      required:  data['twitch_extra_opts']['required']
                        })
    modlist.push({ url: curse_base_url + '/mc-mods/' + data['project_id'], comment: data[:comment] })
    client_config_files.concat data['client_config_files'] if data['client_config_files']
  end
end

version_split = node[:forge_server][:installer][:version].split('-')

pack_version = 0

run_context.cookbook_collection.each do |_,cookbook|
  pack_version = cookbook.version if cookbook.name.eql? 'forge_server'
end

raise Error, "pack_version was not set! Did you rename the forge_server Cookbook?" if pack_version == 0

template build_temp + '/manifest.json' do
  source 'forge_pack/forge_manifest.json.erb'
  variables(
    minecraft_version: version_split[0],
    forge_version:     'forge-' + version_split[1],
    pack_name:         server_name,
    version:           pack_version,
    author:            "The #{server_name} Team",
    files:             Chef::JSONCompat.to_json_pretty(manifest_files)
  )
end

template build_temp + '/modlist.html' do
  source 'forge_pack/forge_modlist.html.erb'
  variables( modlist: modlist )
end

client_config_files.each do |config_file|
  cfg_dir = ::File::dirname config_file

  unless cfg_dir.eql? '.'
    directory overrides_build_temp_dir + '/' + cfg_dir do
      recursive true
    end
  end

  cookbook_file overrides_build_temp_dir + '/' + config_file do
    source 'forge_pack/' + overrides_subdir + '/' + config_file
  end
end
apache_docroot = node['apache']['docroot_dir']
twitch_pack_path = "#{apache_docroot}/#{server_name}-#{pack_version}.zip"

execute 'Creating twitch-zip in apache site' do
  command "/usr/local/bin/zip -r #{twitch_pack_path} *"
  cwd build_temp
  creates twitch_pack_path
end

# TODO: This won't find any files created during this run. Fix this!
template apache_docroot + '/' + 'index.html' do
  source 'index.html.erb'
  variables(
      title: node['forge_server']['forge_pack']['html_greeting'],
      location_dir: node['forge_server']['forge_pack']['location_dir'],
      files: ::Dir.glob("#{apache_docroot}/*.zip").sort
  )
end
