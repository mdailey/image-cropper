class CreateProjectCropImages < ActiveRecord::Migration
  def change
    create_table :project_crop_images do |t|
      t.references :project
      t.references :project_image
      t.integer :crop_number
      t.references :user, index: true, foreign_key: true
      t.decimal :x
      t.decimal :y

      t.timestamps null: false
    end
  end
end
