require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test "should be valid" do
    Tag.all.each do |r|
      assert r.valid?
    end
  end

  test "should validate uniqueness of name" do
    old = tags(:one)
    r = Tag.new name: old.name
    assert !r.valid?
    assert_equal ["has already been taken"], r.errors[:name]
  end

  test "should validate presence of name" do
    old = tags(:one)
    r = Tag.new
    assert !r.valid?
    assert_equal ["can't be blank"], r.errors[:name]
  end
end
