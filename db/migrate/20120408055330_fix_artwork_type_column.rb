class FixArtworkTypeColumn < ActiveRecord::Migration
  def up
  	rename_column :show_artworks, :type, :basetype
  end

  def down
  end
end
