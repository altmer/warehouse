# frozen_string_literal: true


class ApiController < ActionController::API
  include JsonFormatable

  # Mock current user
  def authenticate_request!
    @current_user = User.first
  end
end

