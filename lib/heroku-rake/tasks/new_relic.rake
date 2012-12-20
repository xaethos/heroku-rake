namespace :new_relic do

  task :disable do
    new_relic_app.disable
  end

  task :enable do
    new_relic_app.enable
  end

  def new_relic_app
    ENV['TO'] ||= DEFAULT_REMOTE
    config = NEW_RELIC_APPLICATIONS[ENV['TO'].to_sym]
    NewRelicApplication.new config
  end

end
