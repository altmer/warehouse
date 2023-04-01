# frozen_string_literal: true

class JsonWebToken
  EXPIRE_IN = 14.days.from_now.to_i
  VENDOR = "client"

  def self.encode(payload)
    payload.reverse_merge!(meta)

    JWT.encode(payload, ENV["DEVISE_JWT_SECRET_KEY"])
  end

  def self.decode(token)
    data = JWT.decode(token, ENV["DEVISE_JWT_SECRET_KEY"])

    data.first
  end

  def self.valid_payload(payload)
    return false if expired(payload) || payload["iss"] != meta[:iss] || payload["aud"] != meta[:aud]

    true
  end

  def self.meta
    {
        exp: EXPIRE_IN,
        iss: "Hive Logistics GmbH",
        aud: VENDOR
    }
  end

  def self.expired(payload)
    Time.at(payload["exp"]) < Time.now
  end
end
