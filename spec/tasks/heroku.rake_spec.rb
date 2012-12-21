require 'spec_helper'

describe 'heroku rake tasks' do

  subject {
    task.reenable
    task.invoke
    $system
  }

  before do
    stub_const 'DEFAULT_REMOTE', default_remote
    stub_const 'HEROKU_GIT_REMOTES', heroku_git_remotes

    Rake::Task['heroku:heroku_command_line_client'].clear
  end

  let(:default_remote) { 'production' }
  let(:heroku_git_remotes) {{ production: heroku_app_name }}
  let(:heroku_app_name) { 'heroku-app-name' }

  describe 'push', silence: true do
    let(:task) { Rake::Task['heroku:push'] }

    before do
      Git.stub(:open).with('.').and_return mock_git_repo

      mock_git_repo.stub(:remotes).and_return [ mock_git_remote ]
      mock_git_repo.stub(:current_branch).and_return current_branch
    end

    let(:mock_git_repo) { mock(:git).as_null_object }
    let(:mock_git_remote) { mock(:remote, name: default_remote, url: "git@heroku:#{heroku_app_name}.git") }
    let(:current_branch) { 'awesome-features' }

    it "pushes the current branch to the heroku_app's master branch" do
      should == "git push #{default_remote} #{current_branch}:master\n"
    end
  end

  describe 'restart' do
    let(:task) { Rake::Task['heroku:restart'] }
    it { should == "heroku restart --app heroku-app-name\n" }
  end

  describe 'ping' do
    let(:heroku_app_domains) { "example.com\n #{app_domain}" }
    let(:app_domain)    { 'www.example.com' }
    let(:task) { Rake::Task['heroku:ping'] }

    before do
      $backtick_response = heroku_app_domains
      stub_const 'PING_ENDPOINT', ping_endpoint
    end

    after do
      $backtick_response = nil
    end

    let(:ping_endpoint) { '/stats' }

    it "curls the PING_ENDPOINT to warm the dynos" do
      should == "curl http://#{app_domain}#{ping_endpoint}\n"
    end

    context "when no domains are registered" do
      let(:heroku_app_domains) { "No domain names" }

      it "defaults to the heroku domain" do
        should == "curl http://#{heroku_app}.herokuapp.com#{ping_endpoint}\n"
      end
    end
  end

  describe 'db:backup' do
    let(:task) { Rake::Task['heroku:db:backup'] }
    it { should == "heroku pgbackups:capture --app heroku-app-name\n" }
  end

  describe 'db:backup', silence: true do
    let(:task) { Rake::Task['heroku:db:migrate'] }
    it { should == "heroku run rake db:migrate --app heroku-app-name\n" }
  end

  describe 'maintenance:on' do
    let(:task) { Rake::Task['heroku:maintenance:on'] }
    it { should == "heroku maintenance:on --app heroku-app-name\n" }
  end

  describe 'maintenance:off', silence: true do
    let(:task) { Rake::Task['heroku:maintenance:off'] }
    it { should == "heroku maintenance:off --app heroku-app-name\n" }
  end

end
