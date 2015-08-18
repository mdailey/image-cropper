class ProjectCropImage < ActiveRecord::Base
  belongs_to :project
  belongs_to :project_image
  belongs_to :user
  track_who_does_it :creator_foreign_key => "user_id", :updater_foreign_key => "user_id"
end
