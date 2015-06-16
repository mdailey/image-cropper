#!/bin/bash

set -e

if [ `basename \`pwd\`` = "scripts" ]; then
  cd ..
fi

if [ `basename \`pwd\`` = "test" ]; then
  cd ..
fi

if [ ! -d "image_cropper/" ]; then
  echo "$0: error: must be run at the top of the project tree"
  exit -1
fi

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
