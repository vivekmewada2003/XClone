# frozen_string_literal: true

# == schema informations
#
# Table name: follows
# t.integer "follower_id"
# t.integer "followee_id"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'
end
