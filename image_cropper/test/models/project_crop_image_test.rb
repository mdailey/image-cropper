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

  #test "should validate coords" do
  #  pci = ProjectCropImage.new
  #  assert !pci.valid?
  #  assert_equal ["needs 4 coordinates"], pci.errors[:project_crop_image_cords]
  #  assert_equal ["can't be blank"], pci.errors[:project_image]
  #end

end
