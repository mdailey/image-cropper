require 'test_helper'

class Cropper::ProjectCropImagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_project, :initialize_project_image, :initialize_project_crop_image

  # called after every single test
  def teardown
    @project = nil
    @project_image = nil
  end

  test "should authorize get index" do
    get :index, project_id: @project, project_image_id: @project_image
    assert_redirected_to new_user_session_path
  end

  test "should get index" do
    sign_in users(:cropper)
    get :index, project_id: @project, project_image_id: @project_image
    assert_response :success
  end

  test "should authorize get create" do
    post :create, project_id: @project, project_image_id: @project_image, project_crop_image: {project_image_id: @project_image.id, image: "20150922205514.jpg"}, cords: {"0"=>{"x"=>"78.51666259765625", "y"=>"339"}, "1"=>{"x"=>"78.51666259765625", "y"=>"271"}, "2"=>{"x"=>"183.51666259765625", "y"=>"268"}, "3"=>{"x"=>"186.51666259765625", "y"=>"340"}}
    assert_redirected_to new_user_session_path
  end

  test "should get create" do
    sign_in users(:cropper)
    post :create, project_id: @project, project_image_id: @project_image, project_crop_image: {project_image_id: @project_image.id, image: "20150922205514.jpg"}, cords: {"0"=>{"x"=>"78.51666259765625", "y"=>"339"}, "1"=>{"x"=>"78.51666259765625", "y"=>"271"}, "2"=>{"x"=>"183.51666259765625", "y"=>"268"}, "3"=>{"x"=>"186.51666259765625", "y"=>"340"}}, format: :json
    assert_response :accepted
  end

  test "should authorize destroy" do
    delete :destroy, project_id: @project, project_image_id: @project_image, id: @project_crop_image.id
    assert_redirected_to new_user_session_path
  end

  test "should destroy" do
    sign_in users(:cropper)
    delete :destroy, project_id: @project, project_image_id: @project_image, id: @project_crop_image.id, format: :json
    assert_response :accepted
    #assert_redirected_to cropper_project_project_image_project_crop_images_path(@project, @project_image)
  end

  private
  def initialize_project
    @project = projects(:one)
  end

  def initialize_project_image
    @project_image = project_images(:one)
  end

  def initialize_project_crop_image
    @project_crop_image = project_crop_images(:one)
  end
end
