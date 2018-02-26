default['forge_server']['mods'] = {
                                    'name' => {
                                        'version' => '',
                                        'url' => '',
                                        'server_config' => %(path/file1 file2 file3),
                                        'client_config' => %(file1),
                                        'server' => true,
                                        'client' => true
                                    },
                                    'name2' => {
                                        'version' => '',
                                        'url' => '',
                                        'server_config' => %(file1 file2),
                                        'client_config' => nil,
                                        'server' => false,
                                        'client' => true
                                    }
                                  }
