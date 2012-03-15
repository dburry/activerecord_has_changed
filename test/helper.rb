
if ENV.has_key?('USE_SIMPLECOV')
  require 'simplecov'
  SimpleCov.start do
    add_group 'Libraries', 'lib'
  end
end

require 'test/unit'
begin
  require 'shoulda'
rescue LoadError
  puts 'WARNING: missing shoulda library, cannot continue run tests'
  exit
end

ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
Rails.backtrace_cleaner.remove_silencers!

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'activerecord_has_changed'

class Test::Unit::TestCase
end
