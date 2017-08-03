require 'test_helper'

class Uploader::ProjectsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_project

  # called after every single test
  def teardown
    @project = nil
  end

  def setup_files
    dummy_image = File.join(Rails.root.to_s, 'public', 'doraemon1.jpg')
    Project.all.each do |project|
      dir = File.join(Rails.application.config.projects_dir, project.name)
      Dir.mkdir(dir) unless Dir.exist?(dir)
      project.project_images.each do |image|
        file = File.join(dir, image.image)
        system("cp '#{dummy_image}' '#{file}'") unless File.exist?(file)
        image.project_crop_images.each do |crop|
          user_dir = File.join(dir, crop.user_id.to_s)
          Dir.mkdir(user_dir) unless Dir.exist?(user_dir)
          file = File.join(user_dir, crop.image)
          system("cp '#{dummy_image}' '#{file}'") unless File.exist?(file)
        end
      end
    end
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
    setup_files
    sign_in users(:uploader)
    get :show, id: @project.id, format: :zip
    assert_response :success
    assert_equal 'application/octet-stream', @response.content_type
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
    setup_files
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
    sign_in users(:uploader)
    delete :destroy, id: @project.id
    assert_redirected_to uploader_projects_path
  end

  private

  def initialize_project
    @project = projects(:one)
  end
end
