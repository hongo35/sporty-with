# config valid only for current version of Capistrano
lock "3.8.1"

set :pty, true
set :scm, :git
set :keep_releases, 5
set :application, 'sporty-with'
set :repo_url, 'git@github.com:hongo35/sporty-with.git'
set :migration_role, :db
set :migration_servers, -> { primary(fetch(:migration_role))}
ask(:branch, 'develop')

set :deploy_to, "/var/www/html/#{fetch(:application)}"

set :puma_threads, [4, 16]
set :puma_workers, 0
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"

set :linked_files, %w(config/database.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets public/system public/uploads)

after 'deploy:publishing', 'deploy:restart'

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc 'Upload config files'
  task :upload do
    on roles(:app) do |host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!('config/database.yml', "#{shared_path}/config/database.yml")
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute :sudo, '/etc/init.d/nginx restart'
    end
  end
end
