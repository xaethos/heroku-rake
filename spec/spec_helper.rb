require 'rubygems'
require 'rake'
require File.join File.dirname(__FILE__), *%w(.. lib heroku-rake)

def mock_system_status status
  system("(exit #{status})")
end

def with_backtick_response response, &block
  original_response = $backtick_response = response
  block.call
ensure
  $backtick_response = original_response
end

RSpec.configure do |config|

  config.before do
    $system = ""
    $backtick_response = nil
  end

  config.before(:each, silence: true) do
    $original_stdout = $stdout
    $stdout = File.new '/dev/null', 'w'
  end

  config.after(:each, silence: true) do
    $stdout = $original_stdout
  end

end

def ` cmd
  $backtick_response
end

module FileUtils
  def sh *cmd, &block
    options = (Hash === cmd.last) ? cmd.pop : {}
    unless options[:noop]
      $system << cmd.join(' ')
      $system << "\n"
    end

    nil
  end
end

