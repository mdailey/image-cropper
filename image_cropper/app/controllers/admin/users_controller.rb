class Admin::UsersController < ApplicationController
  def index
    @users = User.order(:name)
  end

  def edit
  end

  def update
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:is_active)
  end
end
