class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include SentientUser
  has_many :users
  has_many :project_users, dependent: :destroy
  belongs_to :role
  devise :database_authenticatable, :registerable, :trackable, :recoverable, :validatable
  validates_uniqueness_of :email
  validates_presence_of :name
end
