class AddPublicToShows < ActiveRecord::Migration
  def change
    add_column :shows, :public, :boolean

  end
end
