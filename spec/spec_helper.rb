require 'rubygems'
require 'rake'
require File.join File.dirname(__FILE__), *%w(.. lib heroku-rake)

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

def ` value
  $system << value
  $system << "\n"
  value
end

def cleanup_system
  $system = ""
end

def capture_stdout
  $original_stdout = $stdout
  $stdout = File.new '/dev/null', 'w'
end

def release_stdout
  $stdout = $original_stdout
end

def mock_exitstatus status
  system("(exit #{status})")
end
