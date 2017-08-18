require 'rake'

Before('@server') do
  #DatabaseCleaner.strategy = :truncation
  #DatabaseCleaner.clean
  #DatabaseCleaner.start
  @server_ppid = Process.fork do
    Dir.chdir Rails.root
    system("RAILS_ENV=test rails s -p 3001 -P tmp/pids/test-server.pid 2>&1 > log/test-server.log")
  end
  sleep 2
end

After('@server') do
  Dir.chdir Rails.root
  server_pid = `cat tmp/pids/test-server.pid`
  Process.kill "INT", server_pid.to_i
  Process.kill "INT", @server_ppid
  system("rm -f tmp/pids/test-server.pid")
  sleep 3
  #DatabaseCleaner.clean
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
  Capybara.use_default_driver
end
