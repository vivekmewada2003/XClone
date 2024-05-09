class Post < ApplicationRecord
  belongs_to :user
  validates :description, presence: true
  has_many_attached :images
end
