class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.integer :crop_points
      t.boolean :isactive, :default => false
      t.references :user
      
      t.timestamps null: false
    end
  end
end
