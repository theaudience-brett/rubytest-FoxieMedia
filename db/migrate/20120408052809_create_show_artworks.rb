class CreateShowArtworks < ActiveRecord::Migration
  def change
    create_table :show_artworks do |t|
      t.integer :show_id
      t.integer :tvdb_id
      t.string :path
      t.string :type
      t.string :subtype
      t.string :language
      t.decimal :rating
      t.string :thumbnail

      t.timestamps
    end
  end
end
