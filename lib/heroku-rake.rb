require "heroku-rake/version"

module Heroku
  module Rake

    module Loader
      load "heroku-rake/tasks/heroku.rake"

      require "heroku-rake/new_relic_application"
      load "heroku-rake/tasks/new_relic.rake"
    end

    if defined? Rails
      class Railtie < ::Rails::Railtie
        rake_tasks do
          include Loader
        end
      end
    else
      include Loader
    end

  end
end
