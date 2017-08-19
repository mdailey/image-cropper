require 'test_helper'

class ProjectImageTest < ActiveSupport::TestCase

  test "should be valid" do
    ProjectImage.all.each do |pi|
      assert pi.valid?
    end
  end

  test "should validate filename" do
    pi = project_images(:one).dup
    assert !pi.valid?
    assert_equal ["has already been taken"], pi.errors[:image]
  end

end
