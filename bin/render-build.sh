#!/usr/bin/env bash

# render.com build script
# see: https://render.com/docs/deploy-rails#create-a-build-script

# exit on error
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
