require 'spec_helper'

describe NewRelicApplication do

  before do
    cleanup_system
    mock_exitstatus 0

    app.stub(:urlify) do |action|
      { action: action,
        account_id: app.account_id,
        application_id: app.application_id,
        api_key: app.api_key }.to_s
    end
  end

  let(:app) {
    NewRelicApplication.new account_id: account_id, application_id: application_id, api_key: api_key
  }

  let(:account_id) { ':account_id' }
  let(:application_id) { ':application_id' }
  let(:api_key) { ':api_key' }

  describe "#disable" do
    subject { app.disable; $system }
    it { should include account_id, application_id, api_key }
    it { should match(/curl.*disable.*#{api_key}"/) }
  end

  describe "#enable" do
    subject { app.enable; $system }
    it { should include account_id, application_id, api_key }
    it { should match(/curl.*enable.*#{api_key}"/) }
  end

end
