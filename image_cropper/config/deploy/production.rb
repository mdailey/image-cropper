
set :scm, :git
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call if deploying?

server 'cropper.pineapplevisionsystems.com',
  user: 'deploy',
  roles: %w{web app db},
  ssh_options: {
    forward_agent: true,
    auth_methods: %w(publickey)
  }

