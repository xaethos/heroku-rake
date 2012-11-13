require "heroku-rake/version"

module Heroku
  module Rake
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load "heroku-rake/tasks/heroku.rake"
      end
    end
  end
end
