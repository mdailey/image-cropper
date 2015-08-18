class ProjectImage < ActiveRecord::Base
  belongs_to :project
  has_many :project_crop_images
  validates_presence_of :image
end
