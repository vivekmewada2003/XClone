class HomesController < ApplicationController
  def index
    @posts = Post.all.reverse
    @post = current_user.posts.new
  end
end
