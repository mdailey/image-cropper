class Uploader::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_uploader
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  after_action :manage_directory, only: [:create, :update]
  after_action :destroy_directory, only: [:destroy]

  def index
    @tags = Tag.order(:name)
  end

  def show
    respond_to do |format|
      format.html { redirect_to uploader_tags_path, notice: 'Invalid format for tag show' }
      format.zip do
        tempfile = Tempfile.new("#{Time.now.strftime("%Y%m%d%H%M%S")}.zip")
        Dir.exist?(@tag_path) || Dir.mkdir(@tag_path)
        Dir.chdir(@tag_path)
        Zip::File.open(tempfile.path, Zip::File::CREATE) do |zip_file|
          zip_file.add("#{@tag.name}", "#{@tag_path}/#{@tag.name}")
        end
        send_file tempfile.path
      end
    end
  end

  def new
    @tag = Tag.new
  end

  def edit
  end

  def create
    @tag = Tag.new(tag_params)
    respond_to do |format|
      if @tag.save
        format.html { redirect_to uploader_tags_path, notice: 'Tag was successfully created.' }
        format.json { render :index, status: :created, location: uploader_tags_path }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to uploader_tags_path, notice: 'Tag was successfully updated.' }
        format.json { render :index, status: :ok, location: uploader_tags_path}
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tag.destroy
    destroy_directory()
    respond_to do |format|
      format.html { redirect_to uploader_tags_path, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
    @tag_name = @tag.name
    @tag_path = Rails.application.config.categories_dir
  end

  def manage_directory
    dir = Rails.application.config.categories_dir
    if !params[:id]
      file_path = File.join(dir, @tag.name)
      Dir.mkdir file_path unless Dir.exist? file_path
    else
      old_file_path = File.join(dir, @tag_name)
      current_file_path = File.join(dir, @tag.name)
      if old_file_path != current_file_path and File.directory?(old_file_path)
        system("rm -rf #{current_file_path}")
        system("mv #{old_file_path} #{current_file_path}")
      end
    end
  end

  def destroy_directory
    if params[:id]
      file_path = File.join(Rails.application.config.categories_dir, @tag.name)
      if File.directory?(file_path)
        system("rm -rf #{file_path}")
      end
    end
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

end
