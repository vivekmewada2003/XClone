class HomesController < ApplicationController
  def index
    @posts = Post.order(created_at: :desc)
    @post = current_user.posts.new
  end
end
