=begin

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

=end

require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::RcovFormatter,
]

SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

def setup_project_crop_image_files
  dummy_image = File.join(Rails.root.to_s, 'public', 'doraemon1.jpg')
  Project.all.each do |project|
    dir = File.join(Rails.application.config.projects_dir, project.name)
    Dir.mkdir(dir) unless Dir.exist?(dir)
    project.project_images.each do |image|
      file = File.join(dir, image.image)
      system("cp '#{dummy_image}' '#{file}'") unless File.exist?(file)
      image.project_crop_images.each do |crop|
        user_dir = File.join(dir, crop.user_id.to_s)
        Dir.mkdir(user_dir) unless Dir.exist?(user_dir)
        file = File.join(user_dir, crop.image)
        system("cp '#{dummy_image}' '#{file}'") unless File.exist?(file)
      end
    end
  end
end
