class Cropper::ProjectCropImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_project_image
  before_action :set_project_crop_images

  def index
    flash[:danger] = "The maximum of cropping point of this project is #{@project.crop_points==99? "N Points" : @project.crop_points}."
    @project_image_min = @project.project_images.first.id
    @project_image_max = @project.project_images.last.id
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @project_crop_images }
    end
  end

  def create
    @project_crop_image = ProjectCropImage.new(project_crop_image_params)
    respond_to do |format|
      if @project_crop_image.save
        format.html { redirect_to  cropper_project_project_image_project_crop_images_path(@project, @project_image) }
        format.json { render json: { success: true }, status: :accepted, location:  cropper_project_project_image_project_crop_images_path(@project, @project_image) }
      else
        format.html { render :index }
        format.json { render json: cropper_project_project_image_project_crop_images_path(@project, @project_image).errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @crop_analyzes = []
    @project_crop_images = ProjectCropImage.where("project_id=? and project_image_id=? and user_id=?", @project.id, @project_image.id, current_user.id)
    respond_to do |format|
      @project_crop_images.select("crop_number").distinct.each do |p|
        @project_crop_image = @project_crop_images.where("crop_number=?", p.crop_number)
        @min_x = @project_crop_image.minimum(:x)
        @max_x = @project_crop_image.maximum(:x)
        @min_y = @project_crop_image.minimum(:y)
        @max_y = @project_crop_image.maximum(:y)
        if (@min_x..@max_x).include?(params[:x].to_i) && (@min_y..@max_y).include?(params[:y].to_i)
          @project_crop_image.destroy_all
        end
      end
      format.html { redirect_to  cropper_project_project_image_project_crop_images_path(@project, @project_image) }
      format.json { render json: { success: true }, status: :accepted, location:  cropper_project_project_image_project_crop_images_path(@project, @project_image) }
    end
  end

  private
  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_project_image
    @project_image = ProjectImage.find(params[:project_image_id])
  end

  def set_project_crop_images
    @project_crop_images = ProjectCropImage.where("project_id=? and project_image_id=? and user_id=?", @project.id, @project_image.id, current_user.id).order(:id)
  end

  def project_crop_image_params
    params.require(:project_crop_image).permit(:project_id, :project_image_id, :crop_number, :x, :y)
  end
end
