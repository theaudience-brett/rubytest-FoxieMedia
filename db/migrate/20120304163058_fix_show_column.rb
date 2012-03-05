class FixShowColumn < ActiveRecord::Migration
  def up
  	rename_column :shows, :ait_time, :air_time
  end

  def down
  end
end
