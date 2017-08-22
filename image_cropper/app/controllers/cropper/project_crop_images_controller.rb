class Cropper::ProjectCropImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_project_user
  before_action :set_project_image
  before_action :set_project_crop_images

  def index
    respond_to do |format|
      format.html do
        flash[:notice] = "Please select objects of type #{@project.pretty_tags} with a maximum of #{@project.crop_points == 99 ? "any number" : @project.crop_points} points. "
        flash[:notice] += "Press ENTER after you're finished with an object. Right click and select Delete to remove a selection."
      end
      format.json { render json: @project_crop_image_cords }
    end
  end

  def create
    @project_crop_image = ProjectCropImage.new(project_crop_image_params)
    if @project_crop_image.tag_id.nil? and @project.tags.length == 1
      @project_crop_image.tag = @project.tags.first
    end
    params[:cords].to_a.each_with_index do |cord|
      @project_crop_image.project_crop_image_cords.push(ProjectCropImageCord.new x: cord[1]["x"].to_f, y: cord[1]["y"].to_f)
    end
    respond_to do |format|
      if @project_crop_image.save
        crop_image
        format.html { redirect_to cropper_project_project_image_project_crop_images_path(@project, @project_image) }
        format.json { render json: { success: true }, status: :accepted, location:  cropper_project_project_image_project_crop_images_path(@project, @project_image) }
      else
        format.html { render :index }
        format.json { render json: { error: @project_crop_image.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @crop_analyzes = []
    @project_crop_images = ProjectCropImage.where("project_image_id=? and user_id=?", @project_image.id, current_user.id)
    respond_to do |format|
      @project_crop_images.each do |project_crop_image|
        @project_crop_image_cords = project_crop_image.project_crop_image_cords
        @min_x = @project_crop_image_cords.minimum(:x)-5
        @max_x = @project_crop_image_cords.maximum(:x)+5
        @min_y = @project_crop_image_cords.minimum(:y)-5
        @max_y = @project_crop_image_cords.maximum(:y)+5
        if @min_x and @max_x and @min_y and @max_y and (@min_x..@max_x).include?(params[:x].to_f) && (@min_y..@max_y).include?(params[:y].to_f)
          project_crop_image.destroy
          path = Rails.application.config.projects_dir
          filename = "#{path}/#{@project.name}/#{current_user.id.to_s}/#{project_crop_image.image}"
          system("rm #{filename}")
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
    @project_crop_images = @project_image.project_crop_images.order(:id)
    @project_crop_image_cords = []
    @project_crop_images.all.each do |pci|
      @project_crop_image_cords.push(pci.image_cords)
    end
  end

  def crop_image
    x_coords, y_coords = @project_crop_image.bounding_box
    input_path = File.join(Rails.application.config.projects_dir, @project.name, @project_image.image)
    output_dir = File.join(Rails.application.config.projects_dir, @project.name, current_user.id.to_s)
    Dir.mkdir output_dir unless Dir.exist? output_dir
    output_path = File.join(output_dir, @project_crop_image.image)
    python_path = File.join(Rails.root, 'lib', 'image_cropper.py')
    system("python #{python_path} -i #{input_path} -o #{output_path} -x #{x_coords} -y #{y_coords}")
  end

  def project_crop_image_params
    params.require(:project_crop_image).permit(:project_image_id, :image, :tag_id)
  end

end
