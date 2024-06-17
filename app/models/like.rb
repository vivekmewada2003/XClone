# frozen_string_literal: true

# == schema informations
#
# Table name: likes
# t.boolean "like"
# t.string "likeable_type", null: false
# t.bigint "likeable_id", null: false
# t.bigint "user_id", null: false
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
# t.index ["user_id"], name: "index_likes_on_user_id"
class Like < ApplicationRecord
  # association
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  # like broadcast to every user
  after_create_commit do
    like_broadcast
  end

  after_destroy do
    like_broadcast
  end

  def like_broadcast
    broadcast_update_to 'all_likes', target: "likeCount_#{self.likeable.id}",
                                     partial: 'likes/like_count',
                                     locals: { post: self.likeable }
  end
end
