require "rvm/capistrano"
require 'bundler/capistrano'

set :application, "turnierapp"

set :deploy_to, "/home/www/cms"
set :deploy_via, :remote_cache
set :repository,  "git@github.com:DanielMSchmidt/turnierApp.git"

set :rvm_ruby_string, 'ruby-1.9.3'
set :rvm_type, :user

set :scm, :git
set :ssh_options, {:forward_agent => true}
set :branch, "master"
set :rails_env, "production"

set :user, "dschmidt"

role :web, "turnierapp.de"                          # Your HTTP server, Apache/etc
role :app, "turnierapp.de"                          # This may be the same as your `Web` server
role :db, "turnierapp.de", :primary => true         # This is where Rails migrations will run


namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "sudo supervisorctl start #{application}:*"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "sudo supervisorctl stop #{application}:*"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo supervisorctl restart #{application}:*"
  end

  task :copy_database_yml do
    run "cp #{shared_path}/database.yml #{release_path}/config"
  end

  task :copy_env do
    run "rm #{release_path}/.env"
    run "cp #{shared_path}/env #{release_path}/.env"
  end
end
before "deploy:assets:precompile", "deploy:copy_database_yml"
before "deploy:assets:precompile", "deploy:link_uploads"
before "foreman:export", "deploy:copy_env"

namespace :foreman do
  desc "Export the Procfile to supervisord scripts"
  task :export, :roles => :app do
    run [
      "cd #{current_path}",
      "bundle exec foreman export supervisord #{shared_path} -a #{application} -u #{user} -l #{shared_path}/log  -f #{current_path}/Procfile -c app=1",
    ].join(' && ')
  end
end