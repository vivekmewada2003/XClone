class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  has_many :likes, as: :likeable, dependent: :destroy

  belongs_to :parent, class_name: 'Post', optional: true
  has_many :replays, class_name: 'Post', foreign_key: 'parent_id', dependent: :destroy

  #post broadcasting to every user
  after_create_commit do 
    if self.parent_id.nil?
      broadcast_prepend_to "all_posts", target: "post_records", partial: "posts/post", locals: { post: self }
    else
      broadcast_prepend_to "all_posts", target: "post_records", partial: "posts/post", locals: { post: self }
      broadcast_update_to "all_posts", target: "replayCount_#{self.parent_id}", partial: "posts/replay_count", locals: { post: self.parent }
    end
  end
  
  after_destroy do 
    broadcast_remove_to "all_posts", target: "post_#{self.id}"
  end

  after_update do 
    broadcast_update_to "all_posts", target: "post_#{self.id}", partial: "posts/post", locals: { post: self }
  end

end
