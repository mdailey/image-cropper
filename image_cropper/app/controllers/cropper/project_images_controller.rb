class Cropper::ProjectImagesController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @project = Project.find(params[:project_id])
    @project_image = @project.project_images.find(params[:id])
    @project_image_min = @project.project_images.first.id
    @project_image_max = @project.project_images.last.id
    @project_crop_images = ProjectCropImage.where("project_id=? and project_image_id=? and user_id=?", @project.id, @project_image.id, current_user.id)
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @project_crop_images }
    end
  end
end
