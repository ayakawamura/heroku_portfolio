class Tag < ApplicationRecord
  has_many :tag_relationships, dependent: :destroy
  has_many :posts, through: :tag_relationships, source: :post

  validates :name, presence: true, length: { maximum: 100 }
end
