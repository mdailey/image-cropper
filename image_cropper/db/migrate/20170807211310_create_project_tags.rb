class CreateProjectTags < ActiveRecord::Migration
  def change
    create_table :project_tags do |t|
      t.references :project, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
