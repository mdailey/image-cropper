class RemoveTagFromProjectUser < ActiveRecord::Migration
  def change
    remove_column :project_users, :tag_id, :integer
  end
end
