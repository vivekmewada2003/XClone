class Like < ApplicationRecord

  #association
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  #like broadcast to every user
  after_create_commit do
    broadcast_update_to "all_likes", target: "likeCount_#{self.likeable.id}", partial: "likes/like_count", locals: { post: self.likeable }
  end

  after_destroy do
    broadcast_update_to "all_likes", target: "likeCount_#{self.likeable.id}", partial: "likes/like_count", locals: { post: self.likeable }
  end
end