# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'
RUBYOPT="-w $RUBYOPT"

API_ONLY=ARGV.include?('-api-only=true')

if ENV["COVERAGE"]
  require 'coveralls'
  require 'simplecov'

  Coveralls.wear!('rails')

  SimpleCov.adapters.define 'rubygem' do
    # Add app to Merit group
    # https://github.com/colszowka/simplecov/pull/104
    add_group 'Merit', 'lib'
    add_group 'DummyApp', 'test/dummy'
    add_filter 'test/dummy/config/initializers'
  end
  SimpleCov.start 'rubygem'
end

if API_ONLY
  require File.expand_path('../dummy/config/environment_api_only.rb', __FILE__)
else
  require File.expand_path('../dummy/config/environment.rb', __FILE__)
end

require 'rails/test_help'
require 'minitest/rails'
require 'mocha/minitest'
require "orm/#{Merit.orm}"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require 'capybara/rails'
Capybara.default_driver   = :rack_test
Capybara.default_selector = :css

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Merit.orm = :active_record if Merit.orm.nil?

def active_record_orm?
  Merit.orm == :active_record
end
