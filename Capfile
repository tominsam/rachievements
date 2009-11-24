load 'deploy'

set :application, "rachievements"
set :domain,      "seatbelt.jerakeen.org"
set :repository,  "git://github.com/jerakeen/rachievements.git"
set :use_sudo,    false
set :deploy_to,   "/home/tomi/CapDeploy/#{application}"
set :scm,         "git"

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

namespace :custom do
  task :config, :roles => :app do
    run "ln -s #{deploy_to}/shared/database.yml #{current_release}/config"
  end
end

after "deploy:update_code", "custom:config"
