require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test "should be valid" do
    Role.all.each do |r|
      assert r.valid?
    end
  end

  test "should validate uniqueness of name" do
    old = roles(:one)
    r = Role.new name: old.name
    assert !r.valid?
    assert_equal ["has already been taken"], r.errors[:name]
  end

  test "should validate presence of name" do
    old = roles(:one)
    r = Role.new
    assert !r.valid?
    assert_equal ["can't be blank"], r.errors[:name]
  end
end
