class Comic < ActiveRecord::Base
  attr_accessible :comic_id, :title, :issue, :thumbnail, :description
  attr_accessible :isbn, :pages, :detail_url

  validates :comic_id, presence: true, uniqueness: true

  has_many :participations
  has_many :characters, through: :participations

  default_scope { order('created_at DESC') }
end
