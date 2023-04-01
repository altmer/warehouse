# frozen_string_literal: true

module JsonFormatable
  extend ActiveSupport::Concern

  def success!(payload = {}, code = nil)
    code ||= :ok

    render json: {success: true, payload: payload}, status: code unless performed?
  end

  def not_found!(errors)
    fail! errors, :not_found
  end

  def fail!(errors, code = nil)
    errors = [errors] if errors.is_a? String

    code ||= :unprocessable_entity

    render json: {success: false, errors: errors}, status: code unless performed?
  end

  def json_payload
    HashWithIndifferentAccess.new(JSON.parse(request.raw_post))
  rescue ::JSON::ParserError
    fail! "wrong payload"
  end
end