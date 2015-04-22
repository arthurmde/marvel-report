class Character < ActiveRecord::Base
  attr_accessible :character_id, :name, :thumbnail, :description, :events_uri, :detail_url, :wiki_url, :comiclink_url

  validates :character_id, presence: true, uniqueness: true

  has_many :participations
  has_many :comics, through: :participations

  class << self
    # finds a character by its name. This method is a shortcut to
    #
    # Examples:
    #
    #  villain = Character['Carnage']
    #  hero = Character['Captain America']
    def [](name)
      self.find_by_name(name)
    end
  end
end
