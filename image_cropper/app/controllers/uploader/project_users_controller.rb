class Uploader::ProjectUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_uploader
  before_action :set_project
  before_action :set_project_user, only: [:update, :destroy]

  def index
    @users = User.all.sort_by(&:name)
  end

  def create
    @project_user = ProjectUser.new(project_user_params)
    respond_to do |format|
      if @project_user.save
        format.html { redirect_to uploader_project_project_users_path(params[:project_id]), notice: 'User was successfully assigned to the project.' }
        format.json { render json: { delete_path: uploader_project_project_user_path(project_id: @project.id, id: @project_user.id, format: :json) }, status: :created }
      else
        format.html { render :new }
        format.json { render json: @project_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project_user.update(project_user_params)
        format.html { redirect_to uploader_project_project_users_path(params[:project_id]), notice: 'User was successfully updated for the project' }
        format.json { render json: { success: true }, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @project_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    user = @project_user.user
    @project_user.destroy
    respond_to do |format|
      format.html { redirect_to uploader_project_project_users_path(params[:project_id]), notice: 'User was successfully unassigned to the project.' }
      format.json { render json: { create_path: uploader_project_project_users_path(project_id: @project.id, project_user: {user_id: user.id, project_id: @project.id}, format: :json) }, status: :ok }
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
