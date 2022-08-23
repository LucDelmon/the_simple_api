# frozen_string_literal: true

class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :login

  # POST /auth/login
  # @return [JSON, nil]
  def login
    @user = User.find_by(email: login_params[:email])
    if @user&.authenticate(login_params[:password])
      exp = 24.hours.from_now

      token = JsonWebToken.encode(user_id: @user.id, exp: exp.to_i)
      render json: { token: token, exp: exp.strftime('%m-%d-%Y %H:%M') }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  # @return [ActionController::Parameters]
  def login_params
    params.permit(:email, :password)
  end
end
