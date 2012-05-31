module ConfigsHelper

  def site_configs(conflist)
    @site_configs = conflist
  end

  def site_configs
    @site_configs ||= AppConfig.all
  end

  def apply_user_confs(userconfs)
    userconfs.each do |conf|
      @site_configs[conf.app_config_id][:confval] = conf.value
    end
  end

  def get_conf_value(configtitle)
    @confval = AppConfig.find_by_confkey(configtitle)
    return @site_configs[@confval.id]
  end

  def get_config_section(configsection)
    @site_configs = AppConfig.find_all_by_section(configsection)
  end


end
