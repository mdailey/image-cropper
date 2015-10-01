class Uploader::ProjectCropImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_uploader
  before_action :set_project

  def index
    #may be use gem 'mapster' 
  end

  private
  def set_project
    @project = Project.find(params[:project_id])
  end
end
