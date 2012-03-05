class AddShowEpisodesIndex < ActiveRecord::Migration
  def up
  	add_index(:episodes, :show_id)
  end

  def down
  	remove_index(:episodes, :column => 'show_id')
  end
end
