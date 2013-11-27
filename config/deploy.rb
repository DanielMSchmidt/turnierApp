require "rvm/capistrano"
require 'bundler/capistrano'
#require "capistrano/setup"
#require "capistrano/deploy"

set :deploy_to, "/home/www/dschmidt/turnierapp"
set :deploy_via, :remote_cache
set :repository,  "git@github.com:DanielMSchmidt/turnierApp.git"
set :default_shell, "/bin/bash -l"

set :rvm_ruby_string, 'ruby-1.9.3'
set :rvm_type, :user

set :scm, :git
set :ssh_options, {:forward_agent => true}
set :branch, "master"
set :rails_env, "production"
set :application, "dschmidt-turnierapp"

set :user, "dschmidt"
set :use_sudo, false
role :web, "hosting.bnck.de"                          # Your HTTP server, Apache/etc
role :app, "hosting.bnck.de"                          # This may be the same as your `Web` server
role :db, "hosting.bnck.de", :primary => true         # This is where Rails migrations will run


namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "sudo supervisorctl start #{application}"
    run "sudo supervisorctl start #{application}-sidekiq"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "sudo supervisorctl stop #{application}"
    run "sudo supervisorctl stop #{application}-sidekiq"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo supervisorctl restart #{application}"
    run "sudo supervisorctl restart #{application}-sidekiq"
  end

  task :copy_database_yml do
    run "cp #{shared_path}/database.yml #{release_path}/config/database.yml"
  end

  task :copy_env do
    run "rm #{release_path}/.env"
    run "cp #{shared_path}/env #{release_path}/.env"
  end
end

before "deploy:assets:precompile", "deploy:copy_database_yml"
after "deploy", "deploy:cleanup"
