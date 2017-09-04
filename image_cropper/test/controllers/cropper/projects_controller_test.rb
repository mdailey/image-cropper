require 'test_helper'

class Cropper::ProjectsControllerTest < ActionController::TestCase
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

  test "should get index" do
    sign_in users(:cropper)
    get :index
    assert_response :success
  end

  private

  def initialize_project
    @project = projects(:one)
  end

end
