class CreateShowsUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :shows_users do |t|
      t.integer :show_id
      t.integer :user_id
      t.integer :show_artwork_id
      t.string :location

      t.timestamps
    end
  end

end
