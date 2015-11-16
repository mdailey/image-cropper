
set :scm, :git
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call if deploying?

server 'cropper.pineapplevisionsystems.com',
  user: 'deploy',
  roles: %w{web app db},
  ssh_options: {
    forward_agent: true,
    auth_methods: %w(publickey)
  }

namespace :deploy do

  namespace :processors do

    desc "Update git repo on image cropper"
    task :pull_repo do
      on roles([:app]) do
        within "#{current_path}" do
          with rails_env: :production do
            puts "Branch is #{fetch(:branch)}"
            rake "processors:pull_repo[#{fetch(:branch)}]"
          end
        end
      end
    end

  end

  namespace :db do

    desc "Create Production Database"
    task :create do
      on roles([:db]) do
        within "#{current_path}" do
          with rails_env: :production do
            rake "db:create"
          end
        end
      end
    end

    desc "Migrate Production Database"
    task :migrate do
      on roles([:db]) do
        within "#{current_path}" do
          with rails_env: :production do
            rake "db:migrate"
          end
        end
      end
    end

    desc "Seed Production Database"
    task :seed do
      on roles([:db]) do
        within "#{current_path}" do
          with rails_env: :production do
            rake "db:seed"
          end
        end
      end
    end

    desc "Drop Production Database"
    task :drop do
      on roles([:db]) do
        within "#{current_path}" do
          with rails_env: :production do
            rake "db:drop"
          end
        end
      end
    end

  end
end
