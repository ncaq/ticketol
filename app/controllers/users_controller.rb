class UsersController < ApplicationController
  before_action :set_user, only: [:show, :suspend, :edit, :update]

  # GET /users
  def index
    if current_user && current_user.admin?
      allow
      @users = User.all
    else
      deny
    end
  end

  # GET /users/1
  def show
    if current_user && (current_user.admin? || current_user.id == @user.id)
      allow
    else
      deny
    end
  end

  def edit
    if current_user && current_user.admin?
      allow
    else
      deny
    end
  end

  # PATCH/PUT /users/1
  def update
    if current_user && current_user.admin?
      allow
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    else
      deny
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    if current_user && current_user.admin?
      allow
      params.require(:user).permit(:role, :suspend)
    else
      deny
    end
  end
end
