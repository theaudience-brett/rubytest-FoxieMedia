class ChangePosterColumn < ActiveRecord::Migration
  def up
  	remove_column :shows, :poster
  	add_column :shows, :show_artwork_id, :integer
  end

  def down
  end
end
