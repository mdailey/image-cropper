class Uploader::ProjectCropImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_uploader
  before_action :set_project

  def index
  end

  def destroy
    @project_crop_image = ProjectCropImage.find(params[:id]).destroy
    remove_crop_image
    respond_to do |format|
      format.html { redirect_to uploader_project_project_crop_images_path(@project), notice: 'Cropped image was successfully destroyed.' }
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
