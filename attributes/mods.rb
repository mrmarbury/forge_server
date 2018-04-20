default['forge_server']['mods']['curse_base_url'] = 'https://minecraft.curseforge.com'
default['forge_server']['mods']['restart_on_update'] = false
default['forge_server']['mods']['listing'] = {
                                               'JourneyMap' => {
                                                   'comment' => 'JourneyMap (by techbrew)',
                                                   'version' => '1.12.2-5.5.2',
                                                   'project_id' => '32274',
                                                   'file_id' => '2498312',
                                                   'server' => false,
                                                   'client' => true,
                                                   'has_config_recipe' => false,
                                                   'twitch_extra_opts' => {
                                                       "required" => true
                                                   }
                                               },
                                               'jei' => {
                                                   'comment' => 'Just Enough Items (JEI) (by mezz)',
                                                   'version' => '1.12.2-4.8.5.147',
                                                   'project_id' => '238222',
                                                   'file_id' => '2522813',
                                                   'server' => false,
                                                   'client' => true,
                                                   'has_config_recipe' => false,
                                                    'twitch_extra_opts' => {
                                                        "required" => true
                                                    }
                                               },
                                               'Aroma1997Core' => {
                                                   'comment' => 'Aroma1997Core (by Aroma1997)',
                                                   'version' => '1.12.2-1.3.0.2',
                                                   'project_id' => '223735',
                                                   'file_id' => '2490298',
                                                   'server' => true,
                                                   'client' => true,
                                                   'has_config_recipe' => false,
                                                   'twitch_extra_opts' => {
                                                       "required" => true
                                                   }
                                               },
                                               'Aroma1997s-Dimensional-World' => {
                                                   'comment' => 'Aroma1997s Dimensional World (by Aroma1997)',
                                                   'version' => '1.12.2-2.0.0.2.b65',
                                                   'project_id' => '60092',
                                                   'file_id' => '2525258',
                                                   'server' => true,
                                                   'client' => true,
                                                   'has_config_recipe' => false,
                                                   'twitch_extra_opts' => {
                                                       "required" => true
                                                   }
                                               },
                                               'AromaBackup' => {
                                                   'comment' => 'Aroma Backup (by Aroma1997)',
                                                   'version' => '1.12.2-2.1.1.3',
                                                   'project_id' => '225658',
                                                   'file_id' => '2490279',
                                                   'server' => true,
                                                   'client' => false,
                                                   'server_addon_dir' => 'backups',
                                                   'has_config_recipe' => false,
                                                   'twitch_extra_opts' => {
                                                       "required" => true
                                                   }
                                               },
                                               'Dynmap' => {
                                                   'comment' => 'Dynmap Forge (by mikeprimm)',
                                                   'version' => '2.6-beta-1-forge-1.12',
                                                   'project_id' => '59433',
                                                   'file_id' => '2436596',
                                                   'server' => true,
                                                   'client' => false,
                                                   'has_config_recipe' => true,
                                                   'server_addon_dir' => 'dynmap',
                                                   'twitch_extra_opts' => {
                                                       "required" => true
                                                   }
                                               },
                                               'LLOverlayReloaded' => {
                                                   'comment' => 'Light Level Overlay Reloaded (by oldjunyi)',
                                                   'version' => '1.1.4-mc1.12',
                                                   'project_id' => '226670',
                                                   'file_id' => '2436231',
                                                   'server' => false,
                                                   'client' => true,
                                                   'client_config_files' => %w( LLOverlayReloaded.cfg ),
                                                   'has_config_recipe' => false,
                                                   'twitch_extra_opts' => {
                                                       "required" => true
                                                   }
                                               }
                                             }

