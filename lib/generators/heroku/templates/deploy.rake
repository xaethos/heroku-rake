HEROKU_GIT_REMOTES = { production: 'heroku-app-name' }
DEFAULT_REMOTE     = 'production'
DEFAULT_TAG        = 'false'
PING_ENDPOINT      = '/ping' # A working URL that can be pinged to spin up your dynos

desc 'Basic deploy to Heroku (no migrations), use TO=remote to specify an environment, use TAG=true to tag your origin repo'
task :deploy => ['heroku:push',
                 'heroku:ping']

namespace :deploy do
  desc 'Deploy to Heroku with migrations, use TO=remote to specify an environment, use TAG=true to tag your origin repo'
  task :migrations => ['heroku:db:backup',
                       'heroku:push',
                       'heroku:db:migrate',
                       'heroku:restart',
                       'heroku:ping',
                       'heroku:tag']

  namespace :migrations do
    desc 'Deploy to Heroku with migrations and maintenance mode, use TO=remote to specify an environment, use TAG=true to tag your origin repo'
    task :safe => ['heroku:maintenance:on',
                   'heroku:db:backup',
                   'heroku:push',
                   'heroku:db:migrate',
                   'heroku:restart',
                   'heroku:maintenance:off',
                   'heroku:ping',
                   'heroku:tag']

  end
end
