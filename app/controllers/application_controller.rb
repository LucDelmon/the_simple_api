# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authorize_request

  # @return [User, JSON, nil]
  def authorize_request
    return if ENV['DISABLE_AUTHENTICATION']

    header = request.headers['Authorization']
    header = header.split.last if header
    begin
      decoded = JsonWebToken.decode(header)
      User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end
end
