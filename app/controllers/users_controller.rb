class UsersController < ApplicationController
  before_action :set_user, only: [:show, :suspend, :edit, :update]

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

  def edit
    if current_user && current_user.admin?
      allow
    else
      deny
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if current_user && current_user.admin?
      allow
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
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
