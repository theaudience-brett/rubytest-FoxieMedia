class AddProcessToShowArtworks < ActiveRecord::Migration
  def change
    add_column :show_artworks, :process, :integer, :default => 0

  end
end
