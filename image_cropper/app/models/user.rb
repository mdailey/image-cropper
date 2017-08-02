class User < ActiveRecord::Base
  include SentientUser
  has_many :users
  has_many :project_users, dependent: :destroy
  has_many :project_crop_images, dependent: :destroy
  belongs_to :role
  devise :database_authenticatable, :registerable, :trackable, :recoverable, :validatable
  validates_uniqueness_of :email
  validates_presence_of :name
end
