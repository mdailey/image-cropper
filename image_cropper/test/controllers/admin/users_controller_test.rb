require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_project

  # called after every single test
  def teardown
    @user = nil
  end

  test "should authorize get index" do
    get :index
    assert_redirected_to new_user_session_path
  end

  test "should get index" do
    sign_in users(:admin)
    get :index
    assert_response :success
  end

  test "should authorize get new" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "should authorize update" do
    patch :update, id: @user.id, user: {}
    assert_redirected_to new_user_session_path
  end

  test "should update" do
    sign_in users(:admin)
    patch :update, id: @user.id, user: {name: 'Cropped User'}
    assert_redirected_to admin_users_path
  end

  private
  def initialize_project
    @user = users(:cropper)
  end

end
