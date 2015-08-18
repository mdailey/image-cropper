require 'test_helper'

class Cropper::ProjectImagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_project, :initialize_project_image

  # called after every single test
  def teardown
    @project = nil
    @project_image = nil
  end

  test "should authorize get show" do
    get :show, project_id: @project.id, id: @project_image.id
    assert_redirected_to new_user_session_path
  end

  test "should get show" do
    sign_in users(:cropper)
    get :show, project_id: @project.id, id: @project_image.id
    assert_response :success
  end

  private
  def initialize_project
    @project = projects(:one)
  end

  def initialize_project_image
    @project_image = project_images(:one)
  end

end
