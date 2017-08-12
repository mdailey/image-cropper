class ProjectCropImage < ActiveRecord::Base
  #belongs_to :project, through: :project_images
  belongs_to :project_image
  belongs_to :user
  belongs_to :tag
  has_many :project_crop_image_cords, dependent: :destroy
  has_one :project, through: :project_image
  track_who_does_it :creator_foreign_key => "user_id", :updater_foreign_key => "user_id"
  validates_presence_of :project_image, :image, :tag

  validate :number_of_coords_must_be_consistent

  def number_of_coords_must_be_consistent
    return unless self.project
    num_expected = self.project.crop_points
    if num_expected < 99 and num_expected != self.project_crop_image_cords.size
      self.errors.add(:project_crop_image_cords, "should be of size #{num_expected}")
    end
  end

  def image_cords
    cords = {}
    cords[:id] = self.id
    image_cords = self.project_crop_image_cords
    cords[:cords] = []
    image_cords.each do |image_cord|
      cords[:cords] << {
        x: image_cord.x,
        y: image_cord.y
      }
    end
    return cords
  end

end
