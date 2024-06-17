# frozen_string_literal: true

# home controller
class HomeController < ApplicationController
  def index
    @posts = Post.where(repost_id: nil).order(created_at: :desc)
    @post = current_user.posts.new
  end

  def suggest
    query = params[:query]
    hashtags = Hashtag.where('name LIKE ?', "%#{query}%").limit(10)
    render json: hashtags.map(&:name)
  end
end
