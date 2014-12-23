class CreateEventCharacters < ActiveRecord::Migration
  def self.up
  	create_table :event_characters do |t|
      t.references :event
      t.references :character
    end
  end

  def self.down
    drop_table :event_characters
  end
end
