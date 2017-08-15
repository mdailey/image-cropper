class Cropper::ProjectImagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @project = Project.find(params[:project_id])
    @project_image = @project.project_images.find(params[:id])
    @project_crop_images = ProjectCropImage.where("project_image_id=? and user_id=?", @project_image.id, current_user.id).order(:id)
    @project_crop_image_cords = []
    @project_crop_images.all.each do |pci|
      @project_crop_image_cords.push(pci.image_cords)
    end
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @project_crop_image_cords }
    end
  end

end
