set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

ssh_options[:forward_agent] = true

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
require "rvm/capistrano" 
set :rvm_type, :system

require 'bundler/capistrano'

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :use_sudo, false
default_run_options[:pty] = true

set :scm, :git
set :repository, "git@github.com:nomatteus/dinesafe.git"
set :deploy_via, :remote_cache

#############################################################
#   Tasks
#############################################################

namespace :deploy do
  task :link_settings, :roles => :app do
    run "ln -s #{shared_path}/config/settings.yml #{release_path}/config/settings.yml"
    run "ln -s #{shared_path}/config/newrelic.yml #{release_path}/config/newrelic.yml"
    run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :copy_old_sitemap do
    run "if [ -e #{previous_release}/public/sitemap_index.xml.gz ]; then cp #{previous_release}/public/sitemap* #{current_release}/public/; fi"
  end
end

after 'deploy:finalize_update', 'deploy:link_settings'
after 'deploy:finalize_update', 'deploy:copy_old_sitemap'

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

require './config/boot'
