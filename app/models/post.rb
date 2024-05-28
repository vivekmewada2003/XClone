class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  has_many :likes, as: :likeable, dependent: :destroy

  #post broadcasting to every user
  after_create do 
    broadcast_prepend_to "all_posts", target: "each_post", partial: "posts/post", locals: { post: self }
  end

end
