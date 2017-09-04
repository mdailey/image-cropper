require 'test_helper'

class Uploader::TagsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_tag

  # called after every single test
  def teardown
    @tag = nil
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

  test "should get index json" do
    sign_in users(:uploader)
    get :index, format: :json
    assert_response :success
  end

  test "should authenticate get new" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    sign_in users(:uploader)
    get :new
    assert_response :success
  end

  test "should authenticate create" do
    post :create, tag: {name: "animal"}
    assert_redirected_to new_user_session_path
  end

  test "should authorize create" do
    sign_in users(:cropper)
    post :create, tag: {name: "animal"}
    assert_response :unauthorized
  end

  test "should create" do
    sign_in users(:uploader)
    post :create, tag: {name: "animal"}
    assert_redirected_to uploader_tags_path()
  end

  test "should validate create" do
    sign_in users(:uploader)
    post :create, tag: {name: @tag.name}, format: :json
    assert_response :unprocessable_entity
  end

  test "should authenticate update" do
    patch :update, id: @tag.id, tag: {name: "meow"}
    assert_redirected_to new_user_session_path
  end

  test "should authorize update" do
    sign_in users(:cropper)
    patch :update, id: @tag.id, tag: {name: "meow"}
    assert_response :unauthorized
  end

  test "should update" do
    sign_in users(:uploader)
    patch :update, id: @tag.id, tag: {name: "meow"}
    assert_redirected_to uploader_tags_path
  end

  test "should validate on update" do
    sign_in users(:uploader)
    patch :update, id: @tag.id, tag: {name: tags(:two).name}, format: :json
    assert_response :unprocessable_entity
  end

  test "should authenticate destroy" do
    delete :destroy, id: @tag.id
    assert_redirected_to new_user_session_path
  end

  test "should authorize destroy" do
    sign_in users(:cropper)
    delete :destroy, id: @tag.id
    assert_response :unauthorized
  end

  test "should destroy" do
    sign_in users(:uploader)
    delete :destroy, id: @tag.id
    assert_redirected_to uploader_tags_path
  end

  private

  def initialize_tag
    @tag = tags(:one)
  end
end
