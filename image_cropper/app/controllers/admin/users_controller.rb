class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_user, only: [:show, :edit, :update]
  before_action :set_projects, only: [:show]

  def index
    @users = User.where("id <> ?", current_user.id).order(:role_id, :name)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        UserMailer.registration_confirmation(@user, user_params[:password]).deliver_later
        format.html { redirect_to admin_users_path, notice: 'User was successfully created.' }
        format.json { render :index, status: :created, location: admin_users_path }
      else
        format.html { render :new }
        format.json { render json: [:admin,@user].errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_users_path, notice: 'User was successfully updated.' }
        format.json { render json: { success: true }, status: :accepted, location: admin_users_path }
      else
        format.html { render :edit }
        format.json { render json: [:admin,@user].errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def set_projects
    @projects = Project.where("isactive = ?",  true).order(:name)
  end

  def user_params
    if !params[:id]
      @password = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
      params[:user][:password] = @password
      params.require(:user).permit(:name, :email, :password, :is_active, :role_id)
    else
      params.require(:user).permit(:name, :email, :password, :is_active, :role_id)
    end
  end
end
