class CreateProjectCropImageCords < ActiveRecord::Migration
  def change
    create_table :project_crop_image_cords do |t|
      t.references :project_crop_image, index: true, foreign_key: true
      t.float :x
      t.float :y
    end
  end
end
