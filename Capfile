load 'deploy' if respond_to?(:namespace) # cap2 differentiator

default_run_options[:pty] = true

set :application, "sinatra_apps"
set :user, "bloople"
set :port, 9979
set :scm, :git
set :repository, "git@github.com:bloopletech/sinatra_apps.git"

set :deploy_to, "/home/bloople/www/#{application}"

set :deploy_via, :remote_cache

set :keep_releases, 2

role :app, "bloople.net"
role :web, "bloople.net"
role :db,  "bloople.net", :primary => true

set :runner, user

namespace :deploy do
  desc "Restart the server"
  task :restart, :roles => :app do
    #sudo "monit -c /etc/monit/monitrc restart rake"
    #run "cd #{deploy_to}/current/;rake clear_caches; exit;", :pty => false
  end

  desc "The spinner task is used by :cold_deploy to start the application up"
  task :spinner, :roles => :app do
    restart
  end

  task :migrate, :roles => :db, :only => { :primary => true } do
  end

  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't
    # save empty folders
=begin
    run <<-CMD
      rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids &&
      mkdir -p #{latest_release}/public &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/log #{latest_release}/log &&
      ln -s #{shared_path}/system #{latest_release}/public/system &&
      ln -s #{shared_path}/pids #{latest_release}/tmp/pids
    CMD
=end

    run <<-CMD
      rm -rf #{latest_release}/tmp/pids &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/pids #{latest_release}/tmp/pids
    CMD
  end

  task :after_update_code, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/lib/configuration.rb #{release_path}/lib/configuration.rb"
    #run "ln -nfs #{deploy_to}/shared/system/blog/assets #{release_path}/blog/public/assets"
    run "rake generate_nginx_config"
  end

  task :after_setup, :roles => :app do
    after_update_code
  end
end

after :deploy, 'deploy:cleanup'