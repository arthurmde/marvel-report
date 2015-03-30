class Character < ActiveRecord::Base
  attr_accessible :character_id, :name, :thumbnail, :description, :events_uri, :detail_url, :wiki_url, :comiclink_url

  validates :character_id, presence: true, uniqueness: true

  has_many :comic_characters
  has_many :comics, through: :comic_characters

  def self.find_all
    characters = []
    results = Marvel.all_characters
    results.each do |result|
      puts "="*100, results, "="*100
      thumbnail = result['thumbnail'] ? result['thumbnail']['path'] : ""
      characters << Character.new(character_id: result['id'],
                       name: result['name'],
                       thumbnail: thumbnail,
                       description: result['description'])
    end
    characters
  end

end
