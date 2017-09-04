class AddRoleToUser < ActiveRecord::Migration
  def change
    remove_column :users, :is_admin if column_exists? :users, :is_admin
    add_column :users, :is_active, :boolean, :default => false
    add_reference :users, :role, index: true, foreign_key: true, default: 3 unless column_exists? :users, :role_id
  end
end
