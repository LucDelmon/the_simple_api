# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  before_action :find_user, except: %i[create index]

  # GET /users
  # @return [JSON, nil]
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/{username}
  # @return [JSON, nil]
  def show
    render json: @user, status: :ok
  end

  # POST /users
  # @return [JSON, nil]
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /users/1
  # @return [JSON, nil]
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # @return [JSON, nil]
  def destroy
    @user.destroy
  end

  private

  # @return [User, JSON, nil]
  def find_user
    @user = User.find(params[:id])
  end

  # @return [ActionController::Parameters]
  def user_params
    params.permit(:email, :password)
  end
end
