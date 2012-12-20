class NewRelicApplication

  include Rake::DSL

  attr_accessor :account_id, :application_id, :api_key

  def initialize config
    self.account_id = config[:account_id]
    self.application_id = config[:application_id]
    self.api_key = config[:api_key]
  end

  def disable
    sh 'curl', urlify('disable')
  end

  def enable
    sh 'curl', urlify('enable')
  end

  private

  def urlify action
    %Q|https://heroku.newrelic.com/accounts/#{account_id}/applications/#{application_id}/ping_targets/#{action} -X POST -H "X-Api-Key: #{api_key}"|
  end

end
