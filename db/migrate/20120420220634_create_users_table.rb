class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :realname
      t.boolean :is_admin, :default => 0
      t.datetime :last_login

      t.timestamps
    end
  end
end
