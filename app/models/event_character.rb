class EventCharacter < ActiveRecord::Base
  self.table_name = 'event_characters'

  attr_accessible :event_id, :character_id, :event, :character

  belongs_to :event
  belongs_to :character
end
