require 'test_helper'

class ProjectCropImageTest < ActiveSupport::TestCase

  test "should be valid" do
    ProjectCropImage.all.each do |pci|
      assert pci.valid?, pci.errors.full_messages
    end
  end

  test "should validate" do
    pci = ProjectCropImage.new
    assert !pci.valid?
    assert_equal ["can't be blank"], pci.errors[:tag]
    assert_equal ["can't be blank"], pci.errors[:image]
    assert_equal ["can't be blank"], pci.errors[:project_image]
  end

  test "should validate coords" do
    pci = ProjectCropImage.new
    pci.project_image = project_images(:one)
    pci.image = 'tmp.png'
    pci.tag = pci.project.tags.first
    assert !pci.valid?
    assert_equal ["should be of size 4"], pci.errors[:project_crop_image_cords]
    4.times { pci.project_crop_image_cords << ProjectCropImageCord.new(x: 10, y: 10) }
    assert pci.valid?
  end

end
