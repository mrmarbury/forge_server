module Forge
  module Helper

    def forge_is_upgradeable(new_version, installed_version)

      if installed_version.to_s.empty?
        Chef::Log.warm "No installed version found ... seems to be the first install? Continuing ..."
        true
      elsif installed_version == new_version
        Chef::Log.warn "Forge versions are equal - Marking as not eligible for update!"
        false
      else
        Chef::Log.warn "Current Forge version:'#{installed_version}' differs from installable pack version" \
                       " #{new_version} - Marking as eligible for update!"
        true
      end
    end
  end
end
