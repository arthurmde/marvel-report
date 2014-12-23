class Event < ActiveRecord::Base
  attr_accessible :event_id, :name, :thumbnail, :description

  validates :event_id, presence: true, uniqueness: true

  has_many :event_characters
  has_many :characters, through: :event_characters
end
