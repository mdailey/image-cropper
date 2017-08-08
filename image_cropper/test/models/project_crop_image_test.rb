require 'test_helper'

class ProjectCropImageTest < ActiveSupport::TestCase

  test "should be valid" do
    ProjectCropImage.all.each do |pci|
      assert pci.valid?
    end
  end

  test "should validate" do
    pci = ProjectCropImage.new
    assert !pci.valid?
    assert_equal ["can't be blank"], pci.errors[:tag]
  end

end
