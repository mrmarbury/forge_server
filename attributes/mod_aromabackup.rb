default['forge_server']['aroma_backup']['compression_type'] = 'zip'
default['forge_server']['aroma_backup']['filename'] = '%world%/Backup--%world%--%year%-%month%-%date%--%hour%-%minute%'
default['forge_server']['aroma_backup']['location'] = './backups'

## Set to 0 to disable backups
default['forge_server']['aroma_backup']['delay'] = 30

default['forge_server']['aroma_backup']['full_backups_to_keep'] = 30
default['forge_server']['aroma_backup']['incremental_backups_to_create'] = 0
default['forge_server']['aroma_backup']['incremental_backups_to_keep'] = 100
default['forge_server']['aroma_backup']['on_startup'] = true
default['forge_server']['aroma_backup']['skip_backup'] = true

default['forge_server']['aroma_backup']['all_players'] = false

## Array with dimension ids to (not) backup
default['forge_server']['aroma_backup']['blacklist'] = []
default['forge_server']['aroma_backup']['whitelist'] = []

default['forge_server']['aroma_backup']['compression_rate'] = 5
default['forge_server']['aroma_backup']['use_whitelist'] = false
