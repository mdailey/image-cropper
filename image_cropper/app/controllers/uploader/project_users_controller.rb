class Uploader::ProjectUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_uploader
  before_action :set_project
  before_action :set_project_user, only: [:update, :destroy]

  def index
    @users = User.order(:name)#.where("role_id=?",3).order(:name)
  end

  def create
    @project_user = ProjectUser.new(project_user_params)
    respond_to do |format|
      if @project_user.save
        format.html { redirect_to uploader_project_project_users_path(params[:project_id]), notice: 'User was successfully assigned to the project.' }
        format.json { render json: { success: true }, status: :accepted, location: uploader_project_project_users_path(params[:project_id]) }
      else
        format.html { render :new }
        format.json { render json: [:uploader,project_user_params[:user_id]].errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_user.update(project_user_params)
        format.html { redirect_to uploader_project_project_users_path(params[:project_id]), notice: 'Tag was successfully assigned to this user' }
        format.json { render json: { success: true }, status: :accepted, location: uploader_project_project_users_path(params[:project_id]) }
      else
        format.html { render :new }
        format.json { render json: [:uploader,project_user_params[:user_id]].errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_user.destroy
    respond_to do |format|
      format.html { redirect_to uploader_project_project_users_path(params[:project_id]), notice: 'User was successfully unassigned to the project.' }
      format.json { render json: { success: true }, status: :accepted, location: uploader_project_project_users_path(params[:project_id]) }
    end
  end

  private
  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_project_user
    @project_user = ProjectUser.find(params[:id])
  end

  def project_user_params
    params.require(:project_user).permit(:user_id, :project_id, :tag_id)
  end
end
