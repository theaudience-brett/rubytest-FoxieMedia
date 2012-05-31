class CreateUsersAppConfigTable < ActiveRecord::Migration
  def change
    create_table :users_app_configs do |t|
      t.integer :user_id
      t.integer :app_config_id
      t.string :value

      t.timestamps
    end
  end
end
