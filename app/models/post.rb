class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  has_many :likes, as: :likeable, dependent: :destroy
  
  #for the reply to the post
  belongs_to :parent, class_name: 'Post', optional: true
  has_many :replays, class_name: 'Post', foreign_key: 'parent_id', dependent: :destroy

  #for the repost
  belongs_to :repost, class_name: 'Post', optional: true
  has_many :reposts, class_name: 'Post', foreign_key: 'repost_id', dependent: :destroy

  #post broadcasting to every user
  after_create do 
    unless self.repost_status
      if self.parent_id.nil?
        broadcast_prepend_to "all_posts", target: "post_records", partial: "posts/post", locals: { post: self }
      else
        broadcast_prepend_to "all_posts", target: "post_records", partial: "posts/post", locals: { post: self }
        broadcast_update_to "all_posts", target: "replayCount_#{self.parent_id}", partial: "posts/replay_count", locals: { post: self.parent }
      end
    end
  end
  
  after_destroy do 
    broadcast_remove_to "all_posts", target: "post_#{self.id}"
    if self.repost_status
      broadcast_update_to "for_repost_count", target: "broadcast_repost_#{ self.repost_id }", partial: "posts/repost_count", locals: { post: Post.find(self.repost_id) }
    end
  end
  
  after_update do 
    broadcast_update_to "all_posts", target: "post_#{self.id}", partial: "posts/post", locals: { post: self }
  end
  
  def repost_call
    broadcast_update_to "for_repost_count", target: "broadcast_repost_#{ self.repost_id }", partial: "posts/repost_count", locals: { post: Post.find(self.repost_id) }
  end

end