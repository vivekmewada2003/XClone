class PostsController < ApplicationController
  before_action :set_post, only: [:destroy, :update, :edit]

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.save
  end

  def replay
    @post = Post.find(params[:post_id])
  end

  def replay_create
    @post = current_user.posts.build(replay_params)
    @post.save
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    if @post.update(post_params)
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy 
    @post.destroy
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def replay_params
    params.require(:post).permit(:content, :parent_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end