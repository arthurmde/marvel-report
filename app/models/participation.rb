class Participation < ActiveRecord::Base
  self.table_name = 'participations'

  attr_accessible :comic_id, :character_id, :comic, :character

  belongs_to :comic
  belongs_to :character
end
