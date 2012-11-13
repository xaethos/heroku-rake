# heroku-rake

heroku-rake is a lightweight gem that provides rake tasks for deploying Rails 
apps to Heroku. It does not attempt to recreate all functionality of the 
[Heroku Toolbelt](https://toolbelt.heroku.com). It is simply a convenience for 
deployment since deploying to Heroku typically involves a series of steps 
(backup, push, migrate) that are easy to forget when running manually. It is 
configurable so you can decide which steps are appropriate for different types 
of deployment.

## Prerequisites

This gem assumes that you have the [Heroku 
Toolbelt](https://toolbelt.heroku.com) installed. It simply shells out to the 
`heroku` command. We're also assuming you've created your Heroku app and the 
necessary Git remotes.

The gem also currently assumes you're using Rails. Pull requests to make it 
framework-agnostic would be welcomed.

## Installation

Add this line to the development group in your application's Gemfile:

```ruby
gem 'heroku-rake'
```

Generate the skeleton deploy tasks:

```shell
rails generate heroku:rake_tasks
```

## Usage & Configuration

Update the constants in lib/tasks/deploy.rake to refelect the Git remotes you 
have set up for Heroku. Out of the box, you will only need to care about three 
rake tasks:

```shell
rake deploy                 # Basic deploy to Heroku (no migrations), use TO=remote to specify an environment
rake deploy:migrations      # Deploy to Heroku with migrations, use TO=remote to specify an environment
rake deploy:migrations:safe # Deploy to Heroku with migrations and maintenance mode, use TO=remote to specify an env...
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
