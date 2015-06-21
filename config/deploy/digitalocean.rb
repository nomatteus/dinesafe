set :domain, "107.170.180.61"
set :branch, "release"
set :rails_env, "production"

role :web, domain
role :app, domain
role :db, domain, primary: true
role :passenger, domain, "107.170.180.61", no_release: true

set :application, "dinesafe.to"
set :user, "deploy"
set :port, 22

set :deploy_to, "/web/dinesafe.to"

set :rails_environment, "production"

set :rvm_ruby_string, 'ruby-2.1.2@dinesafe-production'
set :rvm_gemset_string, 'dinesafe-production'

