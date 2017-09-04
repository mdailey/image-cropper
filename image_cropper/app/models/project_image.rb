class ProjectImage < ActiveRecord::Base
  belongs_to :project
  has_many :project_crop_images
  validates_presence_of :image
  validates_uniqueness_of :image, scope: :project_id
end
