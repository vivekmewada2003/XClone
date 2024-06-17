# frozen_string_literal: true

# == schema informations
#
# Table name: posts
# t.integer "parent_id"
# t.integer "repost_id"
# t.boolean "repost_status", default: false
# t.bigint "user_id", null: false
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.index ["parent_id"], name: "index_posts_on_parent_id"
# t.index ["repost_id"], name: "index_posts_on_repost_id"
# t.index ["user_id"], name: "index_posts_on_user_id"
class Post < ApplicationRecord
  # association
  belongs_to :user
  belongs_to :parent, class_name: 'Post', optional: true
  belongs_to :repost, class_name: 'Post', optional: true
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :replays, class_name: 'Post', foreign_key: 'parent_id', dependent: :destroy
  has_many :reposts, class_name: 'Post', foreign_key: 'repost_id', dependent: :destroy

  has_rich_text :content

  # post broadcasting to every user
  after_create do
    unless self.repost_status
      if self.parent_id.nil?
        post_broadcast
      else
        post_broadcast
        broadcast_update_to 'all_posts', target: "replayCount_#{self.parent_id}",
                                         partial: 'posts/replay_count',
                                         locals: { post: self.parent }
      end
    end
  end

  after_destroy do
    broadcast_remove_to 'all_posts'
    self.repost_status && self && repost_call
  end

  after_update do
    broadcast_update_to 'all_posts', target: "post_#{self.id}", partial: 'posts/post', locals: { post: self }
  end

  def repost_call
    broadcast_update_to 'for_repost_count', target: "broadcast_repost_#{self.repost_id}",
                                            partial: 'posts/repost_count',
                                            locals: { post: Post.find(self.repost_id) }
  end

  def post_broadcast
    broadcast_prepend_to 'all_posts', target: 'post_records', partial: 'posts/post', locals: { post: self }
  end
end
