# frozen_string_literal: true

class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  # @param payload [Object]
  # @param exp [Date, Time]
  # @return [String]
  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  # @param token [String]
  # @return [ActiveSupport::HashWithIndifferentAccess]
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  end
end
