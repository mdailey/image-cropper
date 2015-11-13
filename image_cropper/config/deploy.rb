
# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'image-cropper'
set :repo_url, 'git@vgl-ait.org:ImageCropper'
set :repo_tree, 'image_cropper'
set :deploy_to, '/home/deploy/image_cropper'
set :rbenv_ruby, '2.1.5'
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :keep_releases, 5

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
