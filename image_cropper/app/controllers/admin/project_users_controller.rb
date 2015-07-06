class Admin::ProjectUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_project_user, only: [:destroy]

  def create
    @project_user = ProjectUser.new(project_user_params)
    respond_to do |format|
      if @project_user.save
        format.html { redirect_to admin_user_path(params[:user_id]), notice: 'User was successfully assigned to the project.' }
        format.json { render json: { success: true }, status: :accepted, location: admin_user_path(params[:user_id]) }
      else
        format.html { render :new }
        format.json { render json: [:admin,@user].errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project_user.destroy
    respond_to do |format|
      format.html { redirect_to admin_user_path(params[:user_id]), notice: 'User was successfully unassigned to the project.' }
      format.json { render json: { success: true }, status: :accepted, location: admin_user_path(params[:user_id]) }
    end
  end

  private
  def set_project_user
    @project_user = ProjectUser.find(params[:id])
  end

  def project_user_params
    params.require(:project_user).permit(:user_id, :project_id)
  end

end
