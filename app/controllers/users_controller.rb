class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /users
  # GET /users.json
  def index
    if current_user && current_user.admin?
      allow
      @users = User.all
    else
      deny
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if current_user && (current_user.admin? || current_user.id == @user.id)
      allow
    else
      deny
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
end
