require 'test_helper'

class Uploader::ProjectCropImagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_project

  test "should authenticate get index" do
    get :index, project_id: @project.id
    assert_redirected_to new_user_session_path
  end

  test "should get index" do
    sign_in users(:uploader)
    get :index, project_id: @project.id
    assert_response :success
  end

  test "should authenticate delete" do
    delete :destroy, project_id: @project.id, id: @crop_image.id
    assert_redirected_to new_user_session_path
  end

  test "should authorize delete" do
    sign_in users(:cropper)
    delete :destroy, project_id: @project.id, id: @crop_image.id
    assert_response :unauthorized
  end

  test "should delete" do
    sign_in users(:uploader)
    @controller.stub :system, true do
      delete :destroy, project_id: @project.id, id: @crop_image.id
    end
    assert_redirected_to uploader_projects_path
  end

  private

  def initialize_project
    @crop_image = project_crop_images(:one)
    @project = projects(:one)
  end

end
