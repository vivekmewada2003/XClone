class PostsController < ApplicationController
  before_action :set_post, only: [:destroy, :update, :edit]

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.save
  end

  def replay
    @post = Post.find(params[:post_id])
  end

  def replay_create
    @post = current_user.posts.build(post_params)
    @post.save
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post.update(post_params)
  end

  def destroy 
    @post.destroy
  end

  def repost
    @post = Post.find(params[:post_id])
    if @post.reposts.exists?(user: current_user)
      Post.destroy_by(repost_id: @post.id, user_id: current_user.id)
    else
      @repost = current_user.posts.build(repost_id: @post.id, content: @post.content, repost_status: true )
      @repost.save
      @repost.repost_call
    end
  end

  private

  def post_params
    if request.url.split('/').last == 'replay'
      params.require(:post).permit(:content, :parent_id)
    else
      params.require(:post).permit(:content)
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

end