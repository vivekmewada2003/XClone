# frozen_string_literal: true

# profile controller
class ProfileController < ApplicationController
  before_action :set_user, only: %i[show create follow unfollow]

  def show
    @user = current_user if @user == current_user || @user.nil?
    @posts = @user.posts.order(created_at: :desc)
    @likes = []
    current_user.likes.count.times do |like|
      @likes.push(current_user.likes[like].likeable)
    end
    @replays = @user.posts.where.not(parent_id: nil)
  end

  def new; end

  def create
    current_user.create_profile!(profile_params)
  end

  def follow
    Follow.create_or_find_by(follower_id: current_user.id, followee_id: @user.id)
  end

  def unfollow
    current_user.followed_users.where(follower_id: current_user.id, followee_id: @user.id).destroy_all
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :bio, :avatar)
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end
end
