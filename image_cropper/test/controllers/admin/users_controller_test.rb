require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup :initialize_project

  # called after every single test
  def teardown
    @user = nil
  end

  test "should authenticate show" do
    get :show, id: @user.id
    assert_redirected_to new_user_session_path
  end

  test "should authorize show" do
    sign_in users(:cropper)
    get :show, id: @user.id
    assert_response :unauthorized
  end

  test "should authorize show for uploader" do
    sign_in users(:uploader)
    get :show, id: @user.id
    assert_response :unauthorized
  end

  test "should show" do
    sign_in users(:admin)
    get :show, id: @user.id
    assert_response :success
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

  test "should validate on update" do
    user = User.new name: 'New cropper', email: 'newcropper@hotmail.com', password: 'secret12', role_id: 3, is_active: true
    user.save!
    sign_in users(:admin)
    patch :update, id: user.id, user: { email: users(:cropper).email }
    assert_response :success
    assert_template 'edit'
    assert_select 'div.field_with_errors input#user_email'
  end

  test "should authenticate create" do
    post :create, user: { name: "New cropper", email: "newcropper@hotmail.com", role_id: 3, is_active: true }
    assert_redirected_to new_user_session_path
  end

  test "should authorize create" do
    sign_in users(:cropper)
    post :create, user: { name: "New cropper", email: "newcropper@hotmail.com", role_id: 3, is_active: true }
    assert_response :unauthorized
  end

  test "should create" do
    sign_in users(:admin)
    post :create, user: { name: "New cropper", email: "newcropper@hotmail.com", role_id: 3, is_active: true }
    assert_redirected_to admin_users_path
  end

  test "should validate on create" do
    sign_in users(:admin)
    # Post without email field
    post :create, user: { name: "New cropper", role_id: 3, is_active: true }
    assert_response :success
    assert_template 'new'
    assert_select 'div.field_with_errors input#user_email'
  end

  private

  def initialize_project
    @user = users(:cropper)
  end

end
