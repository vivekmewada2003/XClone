# frozen_string_literal: true

# == schema informations
#
# Table name: hastags
# t.string "name"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.index ["name"], name: "index_hashtags_on_name"
class Hashtag < ApplicationRecord
end
