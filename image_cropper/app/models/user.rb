class User < ActiveRecord::Base
  include SentientUser
  has_many :users
  has_many :project_users, dependent: :destroy
  has_many :project_crop_images, dependent: :destroy
  belongs_to :role
  devise :database_authenticatable, :registerable, :trackable, :recoverable, :validatable
  validates_uniqueness_of :email
  validates_presence_of :name

  def initials
    name.split(/[\s\.]+/).collect { |s| s[0] }.join
  end

  def is_admin?
    role.name.downcase == 'admin'
  end

  def is_uploader?
    role.name.downcase == 'uploader'
  end

end
