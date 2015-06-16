require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should be valid" do
    User.all.each do |u|
      assert u.valid?
    end
  end

  test "should validate" do
    old = users(:cropper)
    u = User.new email: old.email, encrypted_password: old.encrypted_password
    assert !u.valid?
    assert_equal ["has already been taken", "has already been taken"], u.errors[:email]
    assert_equal ["can't be blank"], u.errors[:name]
  end

  test "should default to cropper" do
    u = User.new email: 'xyz@xyz.com', password: "secret", name: 'Joe user'
    #assert u.valid?, u.errors.full_messages
    assert_equal 3, u.role_id
  end

  test "should default to inactive" do
    u = User.new email: 'xyz@xyz.com', password: "secret", name: 'Joe user'
    #assert u.valid?, u.errors.full_messages
    assert_equal false, u.is_active
  end
end
