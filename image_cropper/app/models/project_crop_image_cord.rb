class ProjectCropImageCord < ActiveRecord::Base
  belongs_to :project_crop_image
  validates_presence_of :project_crop_image_id
end
