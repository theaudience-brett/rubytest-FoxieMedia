class UsersAppConfig < ActiveRecord::Base
  belongs_to :user
  belongs_to :app_config

end
