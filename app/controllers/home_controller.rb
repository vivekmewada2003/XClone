class HomeController < ApplicationController
  def index
    @posts = Post.where(repost_id: nil).order(created_at: :desc)
    @post = current_user.posts.new
  end
end