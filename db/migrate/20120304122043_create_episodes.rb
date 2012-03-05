class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :show_id
      t.integer :tvdb_id
      t.integer :season_no
      t.integer :episode_no
      t.string :episode_name
      t.date :first_aired
      t.text :overview
      t.integer :last_update

      t.timestamps
    end
  end
end
