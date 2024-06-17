# frozen_string_literal: true

# == schema informations
#
# Table name: profile
# t.text "name"
# t.string "bio"
# t.bigint "user_id", null: false
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.index ["user_id"], name: "index_profiles_on_user_id"
class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
end
