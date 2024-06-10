class ProfileController < ApplicationController
  def index
    @posts = current_user.posts.order(created_at: :desc)
    @likes = [];
    current_user.likes.count.times do |like|
      @likes.push(current_user.likes[like].likeable)
    end
    @replays = current_user.posts.where.not(parent_id: nil);
  end

  def new
  end

  def create
    current_user.create_profile!(profile_params)
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :bio, :avatar)
  end
end
