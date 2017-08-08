require 'zip'
class Uploader::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_uploader
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = Tag.where("name like ?", "%#{params[:q]}%").order(:name)
    respond_to do |format|
      format.html
      format.json do
        render json: @tags
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
    respond_to do |format|
      format.html { redirect_to uploader_tags_path, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
    @tag_name = @tag.name
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

end
