class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one :profile, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #----------------------------Follow/Unfollow Section---------------------------------#
  # This access the Follow object.
  has_many :followed_users,
           foreign_key: :follower_id,
           class_name: 'Follow',
           dependent: :destroy

  # This accesses the user through the follow object.
  has_many :followees, through: :followed_users, dependent: :destroy

  # This access the Follow object.
  has_many :following_users,
           foreign_key: :followee_id,
           class_name: 'Follow',  
           dependent: :destroy

  # This accesses the user through the follow object.
  has_many :followers, through: :following_users, dependent: :destroy
end
