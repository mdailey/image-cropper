class AddTagToProjectUsers < ActiveRecord::Migration
  def change
    add_reference :project_users, :tag, index: true
  end
end
