class Comic < ActiveRecord::Base
	attr_accessible :comic_id, :title, :issue, :thumbnail, :description

  validates :comic_id, presence: true, uniqueness: true

  has_many :comic_characters
  has_many :characters, through: :comic_characters
end
