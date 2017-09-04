class Tag < ActiveRecord::Base
  has_many :project_users
  has_many :project_tags, dependent: :destroy
  has_many :project_crop_images, dependent: :destroy
  validates_presence_of :name
  validates_uniqueness_of :name
  validates :name, format: { with: /\A[A-Za-z0-9\u0E00-\u0E7F]+\z/,
                             message: "only allows letters and numbers" }
end
