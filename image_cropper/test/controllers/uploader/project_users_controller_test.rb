require 'test_helper'

class Uploader::ProjectUsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_project, :initialize_project_user

  def teardown
    @project = nil
    @project_user = nil
  end

  test "should authenticate get index" do
    get :index, project_id: @project.id
    assert_redirected_to new_user_session_path
  end

  test "should authorize get index" do
    sign_in users(:cropper)
    get :index, project_id: @project.id
    assert_response :unauthorized
  end

  test "should get index" do
    sign_in users(:uploader)
    get :index, project_id: @project.id
    assert_response :success
  end

  test "should authenticate create" do
    post :create, project_id: @project.id
    assert_redirected_to new_user_session_path
  end

  test "should authorize create" do
    sign_in users(:cropper)
    post :create, project_id: @project.id
    assert_response :unauthorized
  end

  test "should create" do
    sign_in users(:uploader)
    post :create, project_id: @project.id, project_user: {project_id: @project.id, user_id: users(:cropper1).id}, format: :json
    assert_response :created
  end

  test "should validate on create" do
    sign_in users(:uploader)
    post :create, project_id: @project.id, project_user: {project_id: @project.id}, format: :json
    assert_response :unprocessable_entity
  end

  test "should update" do
    project_user = @project.project_users.first
    sign_in users(:uploader)
    patch :update, project_id: @project.id, id: project_user.id, project_user: {project_id: @project.id}, format: :json
    assert_response :success
  end

  test "should validate on update" do
    project_user = @project.project_users.first
    sign_in users(:uploader)
    patch :update, project_id: @project.id, id: project_user.id, project_user: {project_id: nil}, format: :json
    assert_response :unprocessable_entity
  end

  test "should authorize get destroy" do
    delete :destroy, project_id: @project.id, id: @project_user.id
    assert_redirected_to new_user_session_path
  end

  test "should get destroy" do
    sign_in users(:uploader)
    delete :destroy, project_id: @project.id, id: @project_user.id, format: :json
    assert_response :success
  end

  private
  def initialize_project
    @project = projects(:one)
  end

  def initialize_project_user
    @project_user = project_users(:one)
  end
end
