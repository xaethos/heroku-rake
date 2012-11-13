module Heroku
  class RakeTasksGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def create_rake_file
      copy_file 'deploy.rake', 'lib/tasks/deploy.rake'
    end
  end
end
