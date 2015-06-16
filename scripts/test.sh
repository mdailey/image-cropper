#!/bin/bash

# Run Rails application tests
cd image_cropper
bundle install --without production
mkdir -p features/reports
bundle exec rake db:reset || exit 2
bundle exec rake db:create:all || exit 3
bundle exec rake db:migrate || exit 4
bundle exec rake db:seed || exit 5
RAILS_ENV=test bundle exec rake ci:setup:minitest test
RAILS_ENV=test xvfb-run -a bundle exec rake cucumber:ci
