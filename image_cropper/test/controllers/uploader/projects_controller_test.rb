require 'test_helper'

class Uploader::ProjectsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_project

  # called after every single test
  def teardown
    @project = nil
  end

  test "should authorize get index" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "should get index" do
    sign_in users(:uploader)
    get :index
    assert_response :success
  end

  test "should authorize get show" do
    get :show, id: @project.id
    assert_redirected_to new_user_session_path
  end

  test "should get show" do
    sign_in users(:uploader)
    get :show, id: @project.id
    assert_response :success
  end

  test "should authorize get new" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    sign_in users(:uploader)
    get :new
    assert_response :success
  end

  test "should authorize get create" do
    get :create, project: {name: "Doraemon", isactive: false, crop_points: 4}
    assert_redirected_to new_user_session_path
  end

  test "should get create" do
    sign_in users(:uploader)
    get :create, project: {name: "Doraemon", isactive: false, crop_points: 4}
    assert_response :success
  end

  test "should authorize update" do
    patch :update, id: @project.id, project: {}
    assert_redirected_to new_user_session_path
  end

  test "should update" do
    sign_in users(:uploader)
    patch :update, id: @project.id, project: {name: 'Gudetama1'}
    assert_redirected_to uploader_project_path(assigns(:project))
  end

  test "should authorize destroy" do
    delete :destroy, id: @project.id
    assert_redirected_to new_user_session_path
  end

  test "should destroy" do
    sign_in users(:uploader)
    delete :destroy, id: @project.id
    assert_redirected_to uploader_projects_path
  end

  private
  def initialize_project
    @project = projects(:one)
  end
end
