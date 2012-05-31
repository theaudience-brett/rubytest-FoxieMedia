require "rvm/capistrano"
require "bundler/capistrano"

set :application, "FoxieMedia"
set :repository,  "git@github.com:theaudience-brett/rubytest-FoxieMedia.git"
set :homepage,    "foxiemedia.ruby.dev.foxienet.com"

set :deploy_to, "/srv/#{homepage}/#{application}"
set :deploy_via, :remote_cache
set :user, "ezfoxie"
set :use_sudo, false
set :scm, :git
set :keep_releases, 5
set :railsenv, "staging"

set :rvm_ruby_string, "ruby-1.9.3-p194@foxmedia"
set :rvm_type, :system

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server "foxienet.com", :app, :web, :db, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
before "deploy:restart", "deploy:migrate"
after "deploy:restart", "deploy:cleanup"
after "deploy", "rvm:trust_rvmrc"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :migrate do
    run "cd #{release_path} && RAILS_ENV=#{railsenv} bundle exec rake db:migrate"
  end
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end
