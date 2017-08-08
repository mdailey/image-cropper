class AddTagToProjectCropImage < ActiveRecord::Migration
  def change
    add_reference :project_crop_images, :tag, index: true, foreign_key: true
  end
end
