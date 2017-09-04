require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get index" do
    sign_in users(:cropper)
    get :index
    assert_response :success
  end

end
