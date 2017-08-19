
require 'cucumber/rails'

ActionController::Base.allow_rescue = false

DatabaseCleaner.strategy = :truncation, {:except => %w[directions locations]}

# Selenium and Poltegeist seem to work OK to test paper.js events but Webkit does not

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Cucumber::Rails::Database.javascript_strategy = :truncation

# Set up geckodriver for Selenium

path = ENV['PATH']
ENV['PATH'] = "#{File.join(Rails.root, '..', 'tools')}:#{path}"

Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.dir'] = File.join(Rails.root, 'tmp/downloads')
  profile['browser.download.folderList'] = 2
  # Suppress "open with" dialog
  profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/zip'
  #, browser: :firefox, profile: profile
  options.profile = profile
  Capybara::Selenium::Driver.new(app, options: options)
end

Before do
  DatabaseCleaner.clean
end

After do
  page.driver.restart if defined?(page.driver.restart)
end

Before('@selenium') do
  Capybara.current_driver = :selenium
end

After('@selenium') do
  Capybara.javascript_driver = :poltergeist
  Capybara.use_default_driver
end
