class Uploader::ProjectCropImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_uploader
  before_action :set_project
  after_action :remove_crop_image, only: [:destroy]

  def index
    #may be use gem 'mapster'
  end

  def destroy
    @project_crop_image = ProjectCropImage.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to uploader_projects_path, notice: 'Cropped Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_project
    @project = Project.find(params[:project_id])
  end

  def remove_crop_image
    @file_path = "#{Rails.root.to_s}/public/system/projects/#{@project.name}/#{@project_crop_image.user_id.to_s}/#{@project_crop_image.image}"
    system("rm #{@file_path}")
  end
end
