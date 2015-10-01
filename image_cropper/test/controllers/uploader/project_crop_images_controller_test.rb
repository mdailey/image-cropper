require 'test_helper'

class Uploader::ProjectCropImagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_project

  test "should authorize get index" do
    get :index, project_id: @project.id
    assert_redirected_to new_user_session_path
  end

  test "should get index" do
    sign_in users(:uploader)
    get :index, project_id: @project.id
    assert_response :success
  end

  private
  def initialize_project
    @project = projects(:one)
  end

end
