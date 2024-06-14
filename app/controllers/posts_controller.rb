class PostsController < ApplicationController
  before_action :set_post, only: [:destroy, :update, :edit]
  before_action :set_post_id, only: [:replay, :repost]

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.save
  end

  def edit
  end

  def update
    @post.update(post_params)
  end

  def destroy 
    @post.destroy
  end

  def replay
  end

  def replay_create
    @post = current_user.posts.build(post_params)
    @post.save
  end

  def repost
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
    @post = Post.find_by(id: params[:id])
  end

  def set_post_id
    @post = Post.find_by(id: params[:post_id])
  end

end