class AddConfigSectionColumn < ActiveRecord::Migration
  def up
  	add_column :configs, :section, :string
  end

  def down
  end
end
