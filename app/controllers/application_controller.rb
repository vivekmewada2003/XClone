# frozen_string_literal: true

# application controller
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
end
