require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "should be valid" do
    Project.all.each do |p|
      assert p.valid?, p.errors.full_messages
    end
  end

  test "should validate uniqueness of name" do
    old = projects(:one)
    p = Project.new name: old.name, crop_points: 2
    assert !p.valid?
    assert_equal ["has already been taken"], p.errors[:name]
  end

  test "should validate presence of name" do
    p = Project.new crop_points: 1
    assert !p.valid?
    assert_equal ["can't be blank", "only allows letters and numbers"], p.errors[:name]
  end

  test "should validate project name" do
    p = Project.new name: '../../../etc/'
    assert !p.valid?
    assert_equal ["only allows letters and numbers"], p.errors[:name]
  end

  test "should return tag tokens" do
    p = projects(:one)
    p.tag_tokens = Tag.all.collect(&:id).join(',')
    assert_equal Tag.all.collect(&:name).sort, p.tags.collect(&:name).sort
  end

end
