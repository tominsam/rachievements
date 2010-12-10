load 'deploy'

set :application, "rachievements"
set :domain,      "seatbelt.jerakeen.org"
set :repository,  "git://github.com/tominsam/rachievements.git"
set :use_sudo,    false
set :deploy_to,   "/home/tomi/CapDeploy/#{application}"
set :scm,         "git"

role :app, domain
role :web, domain
role :db,  domain, :primary => true

namespace :deploy do
  task :start, :roles => :app do
    run "sudo webroar restart rachievements"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "sudo webroar restart rachievements"
  end
end

namespace :custom do
  task :config, :roles => :app do
    run "ln -sf #{deploy_to}/shared/database.yml #{current_release}/config"
  end
  task :bundler do
    run "cd #{release_path} && bundle install"
  end
end

after "deploy:update_code", "custom:config"
after "deploy:update_code", "custom:bundler"
