require 'test_helper'

class Uploader::ProjectUsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_project, :initialize_project_user

  def teardown
    @project = nil
    @project_user = nil
  end

  test "should authorize get create" do
    post :create, project_id: @project.id
    assert_redirected_to new_user_session_path
  end

  test "should get create" do
    sign_in users(:uploader)
    post :create, project_id: @project.id, project_user: {project_id: @project.id, user_id: users(:cropper1).id}, format: :json
    assert_response :accepted
  end

  test "should authorize get destroy" do
    delete :destroy, project_id: @project.id, id: @project_user.id
    assert_redirected_to new_user_session_path
  end

  test "should get destroy" do
    sign_in users(:uploader)
    delete :destroy, project_id: @project.id, id: @project_user.id, format: :json
    assert_response :accepted
  end

  private
  def initialize_project
    @project = projects(:one)
  end

  def initialize_project_user
    @project_user = project_users(:one)
  end
end
