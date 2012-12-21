require "git"

require "heroku-rake/version"
require "heroku-rake/new_relic_application"

module Loader
  load "heroku-rake/tasks/heroku.rake"
  load "heroku-rake/tasks/new_relic.rake"
end

module Heroku
  module Rake

    if defined? Rails
      class Railtie < ::Rails::Railtie
        rake_tasks { include Loader }
      end
    else
      include Loader
    end

  end
end
