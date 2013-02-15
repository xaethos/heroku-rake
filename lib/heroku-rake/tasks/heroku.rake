namespace :heroku do

  task :base => [:heroku_command_line_client, :git_apps]

  task :heroku_command_line_client do
    unless `heroku version` =~ /ruby/
      abort "Please install the heroku toolbelt or command line client"
    end
  end

  task :git_apps => :heroku_command_line_client do
    apps = {}
    remotes = `git remote -v`.split("\n")

    remotes.each do |remote|
      if m = remote.match(/^([^\s]*).*heroku\.com:(.*)\.git\ /)
        apps[m[1].to_sym] = m[2]
      end
    end

    HEROKU_GIT_REMOTES.reverse_merge! apps
  end

  task :push => :base do
    current_branch = `git branch | grep '*' | cut -d ' ' -f 2`.strip
    git_remote     = `git remote -v | grep 'git@heroku.*:#{heroku_app}.git' | grep -e push | cut -f 1 | cut -d : -f 3`.strip

    puts "***** DEPLOYING TO #{heroku_app} *****"
    puts "***** use the TO=git_remote option to specify a different environment *****"

    sh "git push #{git_remote} #{current_branch}:master"
  end

  task :restart => :base do
    sh "heroku restart --app #{heroku_app}"
  end

  task :ping => :base do
    url = `heroku domains --app #{heroku_app}`.split("\n").last.strip
    url = "#{heroku_app}.herokuapp.com" if url[/No domain names/]
    sh "curl http://#{url}#{PING_ENDPOINT}"
  end

  namespace :db do
    task :backup => :base do
      sh "heroku pgbackups:capture --app #{heroku_app}"
    end

    task :migrate => :base do
      puts "***** MIGRATING #{heroku_app} *****"
      sh "heroku run rake db:migrate --app #{heroku_app}"
    end
  end

  namespace :maintenance do
    task :on => :base do
      sh "heroku maintenance:on --app #{heroku_app}"
    end

    task :off => :base do
      sh "heroku maintenance:off --app #{heroku_app}"
    end
  end

  def heroku_app
    ENV['TO'] ||= DEFAULT_REMOTE
    app_name = HEROKU_GIT_REMOTES[ENV['TO'].to_sym]

    app_name
  end
end
