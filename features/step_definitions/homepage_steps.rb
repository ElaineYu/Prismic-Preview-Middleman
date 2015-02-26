require 'capybara'
require 'rspec'
require 'capybara/cucumber'
require "middleman"
require 'capybara/rspec'
require 'middleman-s3_sync'
require 'middleman-livereload'
require 'selenium/webdriver'

Capybara.app = Middleman::Application.server.inst do
  set :root, File.expand_path(File.join(File.dirname(__FILE__), '..'))
  set :environment, :development
  set :show_exceptions, false
end

Given /I (?:visit|go to) the homepage/ do
  if local_test?
    @browser.navigate.to "http://0.0.0.0:4567"
  elsif remote_browser?
    @browser.navigate.to "http://staging-fove.s3-website-us-west-1.amazonaws.com"
  else
    puts "Meh"
  end
end