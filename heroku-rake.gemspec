# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heroku-rake/version'

Gem::Specification.new do |gem|
  gem.name          = "heroku-rake"
  gem.version       = Heroku::Rake::VERSION
  gem.authors       = ["Adam McCrea"]
  gem.email         = ["adam@adamlogic.com"]
  gem.description   = %q{Rake tasks to simpliy Rails deployment to Heroku}
  gem.summary       = %q{Rake tasks to simpliy Rails deployment to Heroku}
  gem.homepage      = "http://github.com/newcontext/heroku-rails"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rake'
  gem.add_dependency 'git'
end
