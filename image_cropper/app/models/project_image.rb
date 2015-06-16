class ProjectImage < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :image
end
