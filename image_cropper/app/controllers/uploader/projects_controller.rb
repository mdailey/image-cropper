require 'zip'

class Uploader::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_uploader
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.order(:name)
  end

  def show
    respond_to do |format|
      format.zip do
        zipfile = make_zip_file(@project)
        send_file zipfile.path, filename: "#{@project.name}.zip"
      end
      format.html
    end
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
        manage_directory
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
        manage_directory
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
      file_path = File.join(Rails.application.config.projects_dir, @project.name)
      Dir.mkdir(file_path) unless Dir.exist?(file_path)
      unzip_images(file_path)
    else
      old_file_path = File.join(Rails.application.config.projects_dir, @project_name)
      current_file_path = File.join(Rails.application.config.projects_dir, @project.name)
      if old_file_path != current_file_path and File.directory?(old_file_path)
        system("rm -rf #{current_file_path}")
        system("mv #{old_file_path} #{current_file_path}")
      end
      unzip_images(current_file_path)
    end
  end

  def unzip_images(file_path)
    if project_params[:images]
      if(File.extname("#{project_params[:images].original_filename}") == ".zip")
        Zip::File.open("#{project_params[:images].path}") do |zipfile|
          zipfile.each do |file|
            this_file_path = "#{file_path}/#{file}"
            zipfile.extract(file, this_file_path) unless File.exist?(this_file_path)
            mimetype = FileMagic.open(:mime) { |fm| fm.file(this_file_path) }
            if mimetype.start_with? 'image'
              dims = Dimensions.dimensions(this_file_path)
              ProjectImage.create(project_id: @project.id, image: file, w: dims[0], h: dims[1])
            end
          end
        end
      else
        file_name = project_params[:images].original_filename
        path = "#{file_path}/#{file_name}"
        File.open(path, 'wb') do |file|
          file.write(project_params[:images].read)
        end
        dims = Dimensions.dimensions(path)
        ProjectImage.create(project_id: @project.id, image: file_name, w: dims[0], h: dims[1])
      end
    end
  end

  def destroy_images
    if params[:id]
      file_path = "#{Rails.root.to_s}/public/system/projects/#{@project.name}"
      @project.project_images.destroy
      if File.directory?(file_path)
        system("rm -rf #{file_path}")
      end
    end
  end

  def project_params
    params.require(:project).permit(:name, :description, :images, :crop_points, :isactive, :tag_tokens)
  end

  def make_cnn_file(project_image)
    outfile = Tempfile.new('foo')
    project_image.project_crop_images.each do |pci|
      outfile.write "#{pci.cnn_data}\n"
    end
    outfile.close
    filename = project_image.image.gsub(/\//, '-')
    if filename =~ /\.[A-Za-z].*$/
      filename.gsub!(/\.[A-Za-z].*$/, '.txt')
    else
      filename = "#{filename}.txt"
    end
    return outfile, filename
  end

  def make_yml_file(project)
    outfile = Tempfile.new('foo')
    outfile.write "%YAML:1.0\n"
    outfile.write "version: 3\n"
    outfile.write "project: #{project.name}\n"
    outfile.write "startFrameNo: 0\n"
    project.project_images.each_with_index do |pi, i|
      pi.project_crop_images.each_with_index do |pci, j|
        outfile.write "frame#{i}region#{j}:\n"
        outfile.write "  imageName: #{pi.image}\n"
        outfile.write "  width: #{pi.w}\n"
        outfile.write "  height: #{pi.h}\n"
        outfile.write "  numPts: #{pci.project_crop_image_cords.size}\n"
        outfile.write "  matPts: !!opencv-matrix\n"
        outfile.write "    rows: #{pci.project_crop_image_cords.size}\n"
        outfile.write "    cols: 2\n"
        outfile.write "    dt: f\n"
        outfile.write "    data: ["
        pci.project_crop_image_cords.each do |coord|
          outfile.write " #{coord.x} #{coord.y}"
        end
        outfile.write " ]\n"
        outfile.write "  attribute: #{pci.tag.name}\n"
      end
    end
    outfile.write "endFrameNo: #{project.project_images.length-1}\n"
    outfile.close
    return outfile
  end


  def make_zip_file(project)
    tempfile = Tempfile.new("zip")
    # Add temp files to this list to prevent their garbage collection before the ZIP file is finished
    tempfiles = []
    Zip::File.open(tempfile.path, Zip::File::CREATE) do |zip_file|
      yml_file = make_yml_file(project)
      tempfiles << yml_file
      zip_file.add("#{project.name}/#{project.name}.yml", yml_file.path)
      project.project_images.each do |pi|
        next unless pi.project_crop_images.size > 0
        path = File.join(Rails.application.config.projects_dir, project.name, pi.image)
        zip_file.add("#{project.name}/original/#{pi.image}", path)
        cnn_file, cnn_filename = make_cnn_file(pi)
        tempfiles << cnn_file
        zip_file.add("#{project.name}/CNN/#{cnn_filename}", cnn_file.path)
        pi.project_crop_images.each do |pci|
          path = File.join(Rails.application.config.projects_dir, project.name, pci.user_id.to_s, pci.image)
          zip_file.add("#{project.name}/crops/#{pci.user_id}/#{pci.image}", path)
        end
      end
    end
    return tempfile
  end

end
