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
    assert_equal ["can't be blank", "only allows letters and numbers"], r.errors[:name]
  end

  test "should validate format of name" do
    tag = Tag.new name: 'Test tag'
    assert !tag.valid?
    assert_equal ["only allows letters and numbers"], tag.errors[:name]
  end

end
