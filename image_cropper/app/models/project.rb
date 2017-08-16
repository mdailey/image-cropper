class Project < ActiveRecord::Base
  belongs_to :user
  has_many :project_images, dependent: :destroy
  has_many :project_users, dependent: :destroy
  has_many :project_tags, dependent: :destroy
  has_many :tags, through: :project_tags
  has_many :users, through: :project_users

  attr_accessor :images
  attr_reader :tag_tokens

  validates_presence_of :name, :crop_points
  validates_uniqueness_of :name
  validates :name, format: { with: /\A[a-zA-Z0-9]+\z/,
                                    message: "only allows letters and numbers" }
  track_who_does_it :creator_foreign_key => "user_id", :updater_foreign_key => "user_id"

  def tag_tokens=(ids)
    self.tag_ids = ids.split(',')
  end

  def pretty_tags
    self.tags.collect(&:name).sort.to_sentence
  end

end
