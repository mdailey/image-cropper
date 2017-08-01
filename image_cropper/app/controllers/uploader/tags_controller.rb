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
    tempfile = Tempfile.new("#{Time.now.strftime("%Y%m%d%H%M%S")}.zip")
    Dir.exist?(@tag_path) || Dir.mkdir(@tag_path)
    Dir.chdir(@tag_path)
    Zip::File.open(tempfile.path, Zip::File::CREATE) do |zip_file|
      if File.directory?("#{@tag_path}/#{@tag.name}")
        Dir.foreach("#{@tag_path}#{@tag.name}") do |item|
          zip_file.add("#{@tag.name}/#{item}", "#{@tag_path}/#{@tag.name}/#{item}")
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to uploader_tags_path }
      format.zip  { send_file tempfile.path }
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
        format.json { render json: [:uploader,@tag].errors, status: :unprocessable_entity }
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
        format.json { render json: [:uploader,@tag].errors, status: :unprocessable_entity }
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
    @tag_path = "#{Rails.root.to_s}/public/system/categories/"
  end

  def manage_directory
    if !params[:id]
      file_path = "#{Rails.root.to_s}/public/system/categories/#{@tag.name}"
      system("mkdir -p #{file_path}")
    else
      old_file_path = "#{Rails.root.to_s}/public/system/categories/#{@tag_name}"
      current_file_path = "#{Rails.root.to_s}/public/system/categories/#{@tag.name}"
      if File.directory?(old_file_path)
        system("mv #{old_file_path} #{current_file_path}") if (old_file_path != current_file_path)
      end
    end
  end

  def destroy_directory
    if params[:id]
      file_path = "#{Rails.root.to_s}/public/system/categories/#{@tag.name}"
      if File.directory?(file_path)
        system("rm -r #{file_path}")
      end
    end
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
