set :rbenv_type, :system
set :rbenv_ruby, '2.4.1'
set :rbenv_custom_path, '/usr/local/rbenv'

# server 'sakura', user: 'hongo35', role: %w{app db web}
server 'sakura', user: 'hongo35', role: %w{app web}
set :stage, :production
set :assets_roles, [:web, :app]
role :app, %w(sakura)
# role :db, %w(sakura), no_release: true
