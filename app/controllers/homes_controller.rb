class HomesController < ApplicationController
  def index
    @posts = Post.all
    # @post = current_user.posts.new
  end
end
