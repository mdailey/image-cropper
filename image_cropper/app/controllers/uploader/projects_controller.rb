require 'zip'
class Uploader::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_uploader
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  after_action :manage_directory, only: [:create, :update]

  def index
    @projects = Project.order(:name)
    if params[:id]
      @project = Project.find(params[:id])
      @project_path = "#{Rails.root.to_s}/public/system/projects/#{@project.name}"
      tempfile = Tempfile.new("#{Time.now.strftime("%Y%m%d%H%M%S")}.zip")
      Dir.chdir(@project_path)
      Zip::File.open(tempfile.path, Zip::File::CREATE) do |zip_file|
        if File.directory?("#{@project_path}")
          Dir.foreach("#{@project_path}") do |item|
            zip_file.add("#{@project.name}/original/#{item}", "#{@project_path}/#{item}") if !File.directory?(item)
          end
          Dir.glob("*/*").each do |item|
            zip_file.add("#{@project.name}/crops/#{item.split("/")[1]}", "#{@project_path}/#{item}")
          end
        end
      end
      respond_to do |format|
        format.zip  { send_file tempfile.path }
      end
    end
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to [:uploader,@project], notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: [:uploader,@project] }
      else
        format.html { render :new }
        format.json { render json: [:uploader,@project].errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to [:uploader,@project], notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: [:uploader,@project] }
      else
        format.html { render :edit }
        format.json { render json: [:uploader,@project].errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    destroy_images()
    respond_to do |format|
      format.html { redirect_to uploader_projects_path, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_project
    @project = Project.find(params[:id])
    @project_name = @project.name
  end

  def manage_directory
    if !params[:id]
      file_path = "#{Rails.root.to_s}/public/system/projects/#{@project.name}"
      system("mkdir -p #{file_path}")
      unzip_images(file_path)
    else
      old_file_path = "#{Rails.root.to_s}/public/system/projects/#{@project_name}"
      current_file_path = "#{Rails.root.to_s}/public/system/projects/#{@project.name}"
      if File.directory?(old_file_path)
        system("mv #{old_file_path} #{current_file_path}") if (old_file_path != current_file_path)
      end
      unzip_images(current_file_path)
    end
  end

  def unzip_images(file_path)
    if project_params[:images]
      if(File.extname("#{project_params[:images].original_filename}") == ".zip")
        Zip::File.open("#{project_params[:images].path}") do |zipfile|
          zipfile.each do |file|
            ProjectImage.create(project_id: @project.id, image: file)
            zipfile.extract(file, "#{file_path}/#{file}") unless File.exist?("#{file_path}/#{file}")
          end
        end
      else
        file_name = project_params[:images].original_filename
        ProjectImage.create(project_id: @project.id, image: file_name)
        File.open("#{file_path}/#{file_name}", 'wb') do |file|
          file.write(project_params[:images].read)
        end
      end
    end
  end

  def destroy_images
    if params[:id]
      file_path = "#{Rails.root.to_s}/public/system/projects/#{@project.name}"
      @project.project_images.destroy
      if File.directory?(file_path)
        system("rm -r #{file_path}")
      end
    end
  end

  def project_params
    params.require(:project).permit(:name, :description, :images, :crop_points, :isactive)
  end
end
