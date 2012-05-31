class RenameGlobalConfigs < ActiveRecord::Migration
  def change
    rename_table :configs, :configs
  end
end
