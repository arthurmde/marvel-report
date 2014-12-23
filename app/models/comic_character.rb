class ComicCharacter < ActiveRecord::Base
  self.table_name = 'comic_characters'

  attr_accessible :comic_id, :character_id, :comic, :character

  belongs_to :comic
  belongs_to :character
end
