class RenameConfigs < ActiveRecord::Migration
  def change
    rename_table :global_configs, :configs
  end
end
