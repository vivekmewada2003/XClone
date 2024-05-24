class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  after_create_commit do 
    broadcast_update_to "all_likes", target: "likeCount_#{self.likeable.id}", partial: "likes/like_count", locals: { post: self.likeable }
  end

  after_destroy do 
    broadcast_update_to "all_likes", target: "likeCount_#{self.likeable.id}", partial: "likes/like_count", locals: { post: self.likeable }
  end
end
