set :domain, "66.175.209.129"
set :branch, "master"
set :rails_env, "production"

role :web, domain
role :app, domain
role :db, domain, :primary => true
role :passenger, domain, "66.175.209.129", :no_release => true

set :application, "dinesafe.to"
set :user, "deploy"
set :port, 22

set :deploy_to, "/web/dinesafe.to"

set :rails_environment, "production"

set :rvm_ruby_string, 'ruby-1.9.3-p286@dinesafe-production'
set :rvm_gemset_string, 'dinesafe-production'

