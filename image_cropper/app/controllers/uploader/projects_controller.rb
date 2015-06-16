require 'zip'
class Uploader::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_uploader
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  after_action :unzip_images, only: [:create, :update]
  after_action :destroy_images, only: [:destroy]

  def index
    @projects = Project.order(:name)
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
    respond_to do |format|
      format.html { redirect_to uploader_projects_path, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_project
    @project = Project.find(params[:id])
  end

  def unzip_images
    if project_params[:images]
      file_path = "#{Rails.root.to_s}/public/system/#{project_params[:name]}"
      system("mkdir -p #{file_path}")
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
      file_path = "#{Rails.root.to_s}/public/system/#{@project.name}"
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
