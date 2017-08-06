#!/bin/bash

set -e

# Prepare application for test
cd image_cropper
bundle install --without production
mkdir -p features/reports
bundle exec rake db:reset
bundle exec rake db:create:all
bundle exec rake db:migrate
bundle exec rake db:seed

# Clean test database
USER="ImageCropper"
PASS="ImageCropper"
TESTDB="image_cropper_test"
CMD="DELETE FROM roles;"
mysql $TESTDB -u $USER --password=${PASS} -e "$CMD"

# Run tests
RAILS_ENV=test bundle exec rake test
RAILS_ENV=test xvfb-run -a bundle exec cucumber --profile default --format junit --out features/reports/ --format json -o features/reports/FEATURES.json

