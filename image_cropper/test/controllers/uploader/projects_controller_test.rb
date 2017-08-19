require 'test_helper'

class Uploader::ProjectsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_project

  # called after every single test
  def teardown
    @project = nil
  end

  test "should authenticate get index" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "should authorize get index" do
    sign_in users(:cropper)
    get :index
    assert_response :unauthorized
  end

  test "should get index" do
    sign_in users(:uploader)
    get :index
    assert_response :success
  end

  test "should authenticate show" do
    get :show, id: @project.id
    assert_redirected_to new_user_session_path
  end

  test "should authorize show" do
    sign_in users(:cropper)
    get :show, id: @project.id
    assert_response :unauthorized
  end

  test "should show" do
    sign_in users(:uploader)
    get :show, id: @project.id
    assert_response :success
  end

  test "should show zip" do
    setup_project_crop_image_files
    sign_in users(:uploader)
    get :show, id: @project.id, format: :zip
    assert_response :success
    assert_equal 'application/zip', @response.content_type
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

  test "should authenticate create" do
    post :create, project: {name: "Doraemon2", isactive: false, crop_points: 4}
    assert_redirected_to new_user_session_path
  end

  test "should authorize create" do
    sign_in users(:cropper)
    post :create, project: {name: "Doraemon2", isactive: false, crop_points: 4}
    assert_response :unauthorized
  end

  test "should create" do
    dummy_image = File.join(Rails.root.to_s, 'public', 'doraemon1.jpg')
    sign_in users(:uploader)
    post :create, project: {name: "Doraemon2", isactive: false, crop_points: 4, images: fixture_file_upload('doraemon1.jpg')}
    assert_redirected_to uploader_project_path(assigns(:project))
  end

  test "should create zip" do
    dummy_image = File.join(Rails.root.to_s, 'public', 'doraemon1.jpg')
    sign_in users(:uploader)
    post :create, project: {name: "Doraemon2", isactive: false, crop_points: 4, images: fixture_file_upload('doraemon.zip')}
    assert_redirected_to uploader_project_path(assigns(:project))
  end

  test "should validate on create" do
    sign_in users(:uploader)
    post :create, project: {name: "Doraemon", isactive: false, crop_points: 4}
    assert_response :success
    assert_template 'new'
  end

  test "should authenticate update" do
    patch :update, id: @project.id, project: {}
    assert_redirected_to new_user_session_path
  end

  test "should authorize update" do
    sign_in users(:cropper)
    patch :update, id: @project.id, project: {}
    assert_response :unauthorized
  end

  test "should update" do
    setup_project_crop_image_files
    sign_in users(:uploader)
    patch :update, id: @project.id, project: {name: 'Gudetama1'}
    assert_redirected_to uploader_project_path(assigns(:project))
  end

  test "should validate on update" do
    sign_in users(:uploader)
    patch :update, id: @project.id, project: {name: 'New bad name'}
    assert_response :success
    assert_template 'edit'
  end

  test "should authorize destroy" do
    delete :destroy, id: @project.id
    assert_redirected_to new_user_session_path
  end

  test "should destroy" do
    setup_project_crop_image_files
    sign_in users(:uploader)
    delete :destroy, id: @project.id
    assert_redirected_to uploader_projects_path
  end

  test "should only extract images from zip" do
    sign_in users(:uploader)
    # Upload zip file with 2 images inside a subdirectory
    post :create, project: {name: "TestSubdir", isactive: false, crop_points: 4, images: fixture_file_upload('images.zip')}
    assert_redirected_to uploader_project_path(assigns(:project))
    assert_equal 2, assigns(:project).project_images.length
  end

  private

  def initialize_project
    @project = projects(:one)
  end
end
