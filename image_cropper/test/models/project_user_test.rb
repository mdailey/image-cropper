require 'test_helper'

class ProjectUserTest < ActiveSupport::TestCase
  test "should be valid" do
    ProjectUser.all.each do |pu|
      assert pu.valid?
    end
  end

  test "should validate presence of project" do
    pu = ProjectUser.new user_id: 2
    assert !pu.valid?
    assert_equal ["can't be blank"], pu.errors[:project_id]
  end

  test "should validate presence of user" do
    pu = ProjectUser.new project_id: 1
    assert !pu.valid?
    assert_equal ["can't be blank"], pu.errors[:user_id]
  end
end
