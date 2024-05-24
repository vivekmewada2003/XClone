class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  has_many :likes, as: :likeable, dependent: :destroy
end
