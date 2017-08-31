class ProjectCropImage < ActiveRecord::Base
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
    if (num_expected == 0 or num_expected.nil?) and self.project_crop_image_cords.size < 1
      self.errors.add(:project_crop_image_cords, "should be of size at least 1")
    elsif num_expected > 0 and num_expected != self.project_crop_image_cords.size
      self.errors.add(:project_crop_image_cords, "should be of size #{num_expected}")
    end
  end

  def crop_descriptor(user)
    coords = {}
    coords[:id] = self.id
    coords[:tag] = self.tag.name
    coords[:owned] = self.user == user
    coords[:owner] = self.user.initials
    image_coords = self.project_crop_image_cords
    coords[:coords] = []
    image_coords.each do |image_coord|
      coords[:coords] << {
        x: image_coord.x,
        y: image_coord.y
      }
    end
    return coords
  end

  def bounding_box
    coords = self.project_crop_image_cords
    w = self.project_image.w
    h = self.project_image.h
    min_x = [0, coords.collect { |c| c.x }.min].max
    max_x = [w-1, coords.collect { |c| c.x }.max].min
    min_y = [0, coords.collect { |c| c.y }.min].max
    max_y = [h-1, coords.collect { |c| c.y }.max].min
    x_coords = [min_x, max_x, max_x, min_x].join(',')
    y_coords = [min_y, min_y, max_y, max_y].join(',')
    return x_coords, y_coords
  end

  def upper_left
    coords = self.project_crop_image_cords
    { x: coords.collect { |c| c.x }.min, y: coords.collect { |c| c.y }.min }
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
