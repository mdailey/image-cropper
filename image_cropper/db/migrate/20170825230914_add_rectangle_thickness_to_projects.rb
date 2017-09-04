class AddRectangleThicknessToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :rectangle_thickness, :integer, default: 1
  end
end
