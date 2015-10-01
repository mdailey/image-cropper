class Tag < ActiveRecord::Base
  has_many :project_users
  validates_presence_of :name
  validates_uniqueness_of :name
end
