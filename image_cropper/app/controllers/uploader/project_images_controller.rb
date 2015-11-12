class Uploader::ProjectImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_uploader
  before_action :set_project, :set_project_image, only: [:destroy]
  after_action :destroy_image, only: [:destroy]

  def destroy
    @project_image.destroy
    respond_to do |format|
      format.html { redirect_to [:edit, :uploader, @project], notice: 'Project Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_project_image
    @project_image = ProjectImage.find(params[:id])
  end

  def destroy_image
    file_path = "#{Rails.root.to_s}/public/system/projects/#{@project.name}"
    system("rm #{file_path}/#{@project_image.image}")
  end
end
