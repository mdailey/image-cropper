require 'test_helper'

class Uploader::TagsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_tag

  # called after every single test
  def teardown
    @tag = nil
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
    get :show, id: @tag.id
    assert_redirected_to new_user_session_path
  end

  test "should get show" do
    sign_in users(:uploader)
    get :show, id: @tag.id
    assert_redirected_to uploader_tags_path
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
    get :create, tag: {name: "animal"}
    assert_redirected_to new_user_session_path
  end

  test "should get create" do
    sign_in users(:uploader)
    get :create, tag: {name: "animal"}
    assert_redirected_to uploader_tags_path()
  end

  test "should authorize update" do
    patch :update, id: @tag.id, tag: {name: "meow"}
    assert_redirected_to new_user_session_path
  end

  test "should update" do
    sign_in users(:uploader)
    patch :update, id: @tag.id, tag: {name: "meow"}
    assert_redirected_to uploader_tags_path()
  end

  test "should authorize destroy" do
    delete :destroy, id: @tag.id
    assert_redirected_to new_user_session_path
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
