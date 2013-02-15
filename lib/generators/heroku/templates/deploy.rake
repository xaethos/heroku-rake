HEROKU_GIT_REMOTES = {} # Parsed from git. Use :remote => "app_name" pairs to override.
DEFAULT_REMOTE     = 'heroku'
PING_ENDPOINT      = '/ping' # A working URL that can be pinged to spin up your dynos

desc 'Basic deploy to Heroku (no migrations), use TO=remote to specify an environment'
task :deploy => ['heroku:push',
                 'heroku:ping']

namespace :deploy do
  desc 'Deploy to Heroku with migrations, use TO=remote to specify an environment'
  task :migrations => ['heroku:db:backup',
                       'heroku:push',
                       'heroku:db:migrate',
                       'heroku:restart',
                       'heroku:ping']

  namespace :migrations do
    desc 'Deploy to Heroku with migrations and maintenance mode, use TO=remote to specify an environment'
    task :safe => ['heroku:maintenance:on',
                   'heroku:db:backup',
                   'heroku:push',
                   'heroku:db:migrate',
                   'heroku:restart',
                   'heroku:maintenance:off',
                   'heroku:ping']

  end
end
