class CreateGlobalConfigs < ActiveRecord::Migration
  def change
    create_table :global_configs do |t|
      t.string :confkey
      t.string :confval

      t.timestamps
    end
  end
end
