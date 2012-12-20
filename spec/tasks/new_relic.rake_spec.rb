require 'spec_helper'

describe 'new_relic rake tasks' do

  before do
    stub_const 'DEFAULT_REMOTE', default_remote
    stub_const 'NEW_RELIC_APPLICATIONS', new_relic_applications

    NewRelicApplication.should_receive(:new).with(
      new_relic_applications[default_remote.to_sym]
    ).and_return mock_new_relic_app
  end

  let(:default_remote) { 'production' }
  let(:new_relic_applications) {{ production: {} }}

  let(:mock_new_relic_app) { mock(:new_relic_app).as_null_object }

  describe 'new_relic:disable' do
    subject(:invoke_task) {
      Rake::Task['new_relic:disable'].invoke
    }

    it 'delegates to the NewRelicApplication object' do
      mock_new_relic_app.should_receive(:disable)
      invoke_task
    end
  end

  describe 'new_relic:enable' do
    subject(:invoke_task) {
      Rake::Task['new_relic:enable'].invoke
    }

    it 'delegates to the NewRelicApplication object' do
      mock_new_relic_app.should_receive(:enable)
      invoke_task
    end
  end

end
