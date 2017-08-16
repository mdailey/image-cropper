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
    cords[:tag] = self.tag.name
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

  def cnn_data
    coords = self.project_crop_image_cords
    w = self.project_image.w
    h = self.project_image.h
    min_x = coords.collect { |c| c.x }.min
    max_x = coords.collect { |c| c.x }.max
    min_y = coords.collect { |c| c.y }.min
    max_y = coords.collect { |c| c.y }.max
    ctr_x = w > 0 ? (min_x.to_f + max_x.to_f) / 2.0 / w.to_f : 0
    ctr_y = h > 0 ? (min_y.to_f + max_y.to_f) / 2.0 / h.to_f : 0
    size_x = w > 0 ? (max_x.to_f - min_x.to_f) / w.to_f : 0
    size_y = h > 0 ? (max_y.to_f - min_y.to_f) / h.to_f : 0
    label = self.tag.id
    return "#{label} #{ctr_x} #{ctr_y} #{size_x} #{size_y}"
  end

end
