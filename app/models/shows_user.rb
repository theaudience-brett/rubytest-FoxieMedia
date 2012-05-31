class ShowsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :show

  belongs_to :show_artwork
end