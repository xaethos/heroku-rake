namespace :heroku do
  task :heroku_command_line_client do
    unless `heroku version` =~ /ruby/
      abort "Please install the heroku toolbelt or command line client"
    end
  end

  task :push => :heroku_command_line_client do
    current_branch = `git branch | grep '*' | cut -d ' ' -f 2`.strip
    git_remote     = `git remote -v | grep 'git@heroku.*:#{heroku_app}.git' | grep -e push | cut -f 1 | cut -d : -f 3`.strip

    puts "***** DEPLOYING TO #{heroku_app} *****"
    puts "***** use the TO=git_remote option to specify a different environment *****"
    if DEFAULT_TAG = 'true'
      puts "***** use the TAG=false to suppress tag the origin repository *****"
    elsif DEFAULT_TAG = 'false'
      puts "***** use the TAG=true to tag the origin repository *****"
    end

    sh "git push #{git_remote} #{current_branch}:master"
  end

  task :restart => :heroku_command_line_client do
    sh "heroku restart --app #{heroku_app}"
  end

  task :ping => :heroku_command_line_client do
    url = `heroku domains --app #{heroku_app}`
    url = "#{heroku_app}.herokuapp.com" if url =~ /no domain names/
    url = url.split("\n").last.strip
    sh "curl http://#{url}#{PING_ENDPOINT}"
  end

  task :tag do
    if tag_this_deploy?
      rev = `git rev-parse HEAD`.strip
      result = `git describe --contains #{rev} 2>&1`
      puts result
      puts heroku_app.to_s

      if !result.include?(heroku_app.to_s) or result.include?('cannot describe')
        version = Time.new.strftime("%Y%m%d%H%M%S")
        sh "git tag -a #{heroku_app}-#{version} -m 'Deploy version to #{heroku_app}: #{version}'"
        sh "git push origin master"
        sh "git push origin master --tags"
      else
        puts "[!] The current revision is already tagged, skipping tag creation."
      end
    else
      puts "... skipping tagging..."
    end
  end

  namespace :db do
    task :backup => :heroku_command_line_client do
      sh "heroku pgbackups:capture --app #{heroku_app}"
    end

    task :migrate => :heroku_command_line_client do
      puts "***** MIGRATING #{heroku_app} *****"
      sh "heroku run rake db:migrate --app #{heroku_app}"
    end
  end

  namespace :maintenance do
    task :on => :heroku_command_line_client do
      sh "heroku maintenance:on --app #{heroku_app}"
    end

    task :off => :heroku_command_line_client do
      sh "heroku maintenance:off --app #{heroku_app}"
    end
  end

  def tag_this_deploy?
    ENV['TAG'] ||= DEFAULT_TAG
    ENV['TAG'] == 'true'
  end

  def heroku_app
    ENV['TO'] ||= DEFAULT_REMOTE
    app_name = HEROKU_GIT_REMOTES[ENV['TO'].to_sym]

    app_name
  end
end
