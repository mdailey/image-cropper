class Cropper::ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @project_ids = []
    ProjectUser.where("user_id=?",current_user.id).each { |project| @project_ids.push(project.project_id) }
    @projects = Project.where(id: @project_ids).order(:name)
  end

end
