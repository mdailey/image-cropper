class ProjectUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :tag
  validates_presence_of :project_id, :user_id
  validates_uniqueness_of :project_id, scope: :user_id
end
