class AppConfig < ActiveRecord::Base
  has_many :users_app_configs
  has_many :users, :through => :users_app_configs

  def self.fetch_section_user(section, user)
    @app_configs = Hash.new

    get_sect = AppConfig.find_all_by_section(section).map

    puts get_sect

    user.users_app_configs.each do |conf|
      puts "#{conf.app_config_id} - #{conf.value}"
      next unless get_sect[conf.app_config_id]
      puts "Made is past the next #{conf.app_config_id} - #{conf.value}"
      get_sect[conf.app_config_id][:confval] = conf.value
    end

    get_sect.each do |s|
      @app_configs[s.confkey.to_s] = s
    end

    @app_configs

  end
end
