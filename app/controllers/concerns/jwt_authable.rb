# frozen_string_literal: true

module JwtAuthable
  extend ActiveSupport::Concern
 
  AUTH_HEADER = "Authorization"

  def authenticate_request!
    return load_current_user! if jwt_payload.present? && JsonWebToken.valid_payload(jwt_payload)

    render json: {success: false, errors: ["invalid request"]}, status: :unauthorized if @current_user.nil?
  end

  def token
    auth = request.headers.fetch(AUTH_HEADER, "")

    auth.split(" ").last if auth.present?
  end

  def jwt_payload
    @jwt_payload ||= HashWithIndifferentAccess.new(JsonWebToken.decode(token))
  rescue JWT::ExpiredSignature, JWT::DecodeError => e
    Rails.logger.error({env: Rails.env, error: e.message})

    nil
  end

  def load_current_user!
    @current_user = User.find_by(id: jwt_payload["uid"])
  end
end