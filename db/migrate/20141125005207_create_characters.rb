class CreateCharacters < ActiveRecord::Migration
  def self.up
  	create_table :characters do |t|
      t.string :type
      t.string :name
      t.string :thumbnail
      t.string :events_uri
      t.integer :character_id
      t.text :description
    end
  end

  def self.down
    drop_table :characters
  end
end
