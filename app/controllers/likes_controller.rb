class LikesController < ApplicationController
  before_action :set_post

  def create
    like = @post.likes.find_by(user: current_user)
      if like
        like.destroy
      else
          @post.likes.create(user: current_user)
      end

    respond_to do |format|
      format.turbo_stream.replace { render partial: "likes/like_button", locals: { post: @post } }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end