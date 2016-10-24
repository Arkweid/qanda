# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'qanda'
set :repo_url, 'git@github.com:Arkweid/qanda.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qanda'
set :deploy_user, 'deployer'


# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/private_pub.yml', 'config/private_pub_thin.yml', '.env'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads'

set :format, :pretty

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml start"
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml stop"
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml restart"
        end
      end
    end
  end
end


#set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
#set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
#set :rails_env, "production"
#namespace :unicorn do
#  task :restart do
#    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
#  end
#  task :start do
#    run "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
#  end
#  task :stop do
#    run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
#  end
#end

after 'deploy:restart', 'private_pub:restart'