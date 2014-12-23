class CreateComicCharacters < ActiveRecord::Migration
  def self.up
  	create_table :comic_characters do |t|
      t.references :comic
      t.references :character
    end
  end

  def self.down
    drop_table :comic_characters
  end
end
