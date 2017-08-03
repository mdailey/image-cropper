class Cropper::ProjectCropImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_project_user
  before_action :set_project_image
  before_action :set_project_crop_images
  after_action :crop_image, only: [:create]

  def index
    flash[:danger] = "The maximum of cropping point of this project is #{@project.crop_points==99? "N Points" : @project.crop_points}. "
    flash[:danger] += "And your cropped object is #{@project_user.tag.name}."
    @project_image_min = @project.project_images.first.id
    @project_image_max = @project.project_images.last.id
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @project_crop_image_cords }
    end
  end

  def create
    @project_crop_image = ProjectCropImage.new(project_crop_image_params)
    @project_crop_image_cords = []
    @project_crop_image.save
    params[:cords].to_a.each_with_index do |cord|
      @project_crop_image_cords.push(save_cords(@project_crop_image.id, cord[1]["x"], cord[1]["y"]))
    end
    respond_to do |format|
      if ProjectCropImageCord.create(@project_crop_image_cords)
        format.html { redirect_to cropper_project_project_image_project_crop_images_path(@project, @project_image) }
        format.json { render json: { success: true }, status: :accepted, location:  cropper_project_project_image_project_crop_images_path(@project, @project_image) }
      else
        format.html { render :index }
        format.json { render json: cropper_project_project_image_project_crop_images_path(@project, @project_image).errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @crop_analyzes = []
    @project_crop_images = ProjectCropImage.where("project_image_id=? and user_id=?", @project_image.id, current_user.id)
    respond_to do |format|
      @project_crop_images.each do |project_crop_image|
        @project_crop_image_cords = ProjectCropImageCord.where(project_crop_image_id: project_crop_image.id)
        @min_x = @project_crop_image_cords.minimum(:x)
        @max_x = @project_crop_image_cords.maximum(:x)
        @min_y = @project_crop_image_cords.minimum(:y)
        @max_y = @project_crop_image_cords.maximum(:y)
        if (@min_x..@max_x).include?(params[:x].to_f) && (@min_y..@max_y).include?(params[:y].to_f)
          project_crop_image.destroy
          system("rm -r #{Rails.root.to_s}/public/system/projects/#{@project.name}/#{current_user.id.to_s}/#{project_crop_image.image}")
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

  def set_project_user
    @project_user = ProjectUser.where("project_id=? and user_id=?", params[:project_id], current_user.id).first
  end

  def set_project_image
    @project_image = ProjectImage.find(params[:project_image_id])
  end

  def set_project_crop_images
    @project_crop_images = ProjectCropImage.where("project_image_id=? and user_id=?", @project_image.id, current_user.id).order(:id)
    @project_crop_image_cords = []
    @project_crop_images.all.each do |pci|
      @project_crop_image_cords.push(pci.image_cords)
    end
  end

  def save_cords(project_crop_image_id, x, y)
    crop_hash = {}
    crop_hash[:project_crop_image_id] = project_crop_image_id
    crop_hash[:x] = x.to_f
    crop_hash[:y] = y.to_f
    return crop_hash
  end

  def crop_image
    if File.file?("#{Rails.root.to_s}/public/system/projects/#{@project.name}/#{@project_image.image}")
      @x_cords = ""
      @y_cords = ""
      @file_path = "#{Rails.root.to_s}/public/system/projects/#{@project.name}"
      @output_path = "#{@file_path}/#{current_user.id.to_s}"
      ProjectCropImageCord.where(project_crop_image_id: @project_crop_image.id).order(:id).each do |crop|
        @x_cords+= @x_cords.empty?? crop.x.to_s : ",#{crop.x.to_s}"
        @y_cords+= @y_cords.empty?? crop.y.to_s : ",#{crop.y.to_s}"
      end
      system("mkdir -p #{@output_path}")
      Dir.chdir("#{Rails.root.to_s}/public")
      @filename = "#{Time.now.strftime("%Y%m%d%H%M%S")}.#{@project_crop_image.image.split(".")[1]}"
      system("python image_cropper.py -i #{@file_path}/#{@project_image.image} -o #{@output_path}/#{@filename} -x #{@x_cords} -y #{@y_cords}")
    end
  end

  def project_crop_image_params
    params.require(:project_crop_image).permit(:project_image_id, :image) #, :cords)
  end
end
