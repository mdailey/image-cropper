class Project < ActiveRecord::Base
  belongs_to :user
  has_many :project_images, dependent: :destroy
  attr_accessor :images
  validates_presence_of :name, :crop_points
  validates_uniqueness_of :name
  track_who_does_it :creator_foreign_key => "user_id", :updater_foreign_key => "user_id"
end
