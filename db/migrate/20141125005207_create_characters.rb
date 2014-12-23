class CreateCharacters < ActiveRecord::Migration
  def self.up
  	create_table :characters do |t|
      t.string :type
      t.string :name
      t.string :thumbnail
      t.string :events_uri
      t.string :detail_url
      t.string :wiki_url
      t.string :comiclink_url
      t.integer :character_id
      t.text :description
    end
  end

  def self.down
    drop_table :characters
  end
end
