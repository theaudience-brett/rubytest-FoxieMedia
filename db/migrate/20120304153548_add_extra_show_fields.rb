class AddExtraShowFields < ActiveRecord::Migration
  def up
  	add_column :shows, :air_day, :string
  	add_column :shows, :ait_time, :string
  	add_column :shows, :first_aired, :date
  	add_column :shows, :network, :string
  	add_column :shows, :rating, :string
  	add_column :shows, :status, :string
  	add_column :shows, :poster, :string
  end

  def down
  end
end
