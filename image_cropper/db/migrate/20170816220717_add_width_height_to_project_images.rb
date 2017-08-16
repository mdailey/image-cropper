require 'dimensions'

class AddWidthHeightToProjectImages < ActiveRecord::Migration

  def up
    add_column :project_images, :w, :integer, null: false
    add_column :project_images, :h, :integer, null: false
    ProjectImage.all.each do |pi|
      path = File.join(Rails.application.config.projects_dir, pi.project.name, pi.image)
      if File.exist? path
        dims = Dimensions.dimensions(path)
        pi.w = dims[0]
        pi.h = dims[1]
        pi.save
      else
        pi.w = 0
        pi.h = 0
        pi.save
      end
    end
  end

  def down
    remove_column :project_images, :w, :integer
    remove_column :project_images, :h, :integer
  end

end
