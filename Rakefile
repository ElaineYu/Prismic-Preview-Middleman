require 'rspec/core/rake_task'
# For multiple browser testing:
require 'rubygems'
require 'json'
require 'cucumber'
require 'cucumber/rake/task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

### Cross browser testing with Browserstack
BROWSERS = JSON.load(open('browsers.json'))

desc 'Run all cross browser tests in parallel'
task :cross_browser do
  BROWSERS.keys.each do |browser_name|
    puts "Cross browser testing against #{browser_name}."

    Rake::Task["cross_browser:#{browser_name}"].execute
  end
end

namespace :cross_browser do
  BROWSERS.keys.each do |browser_name|
    Cucumber::Rake::Task.new("#{browser_name}_run".to_sym) do |task|
      task.cucumber_opts = ["BS_USERNAME=#{ENV['BS_USERNAME']} BS_AUTHKEY=#{ENV['BS_AUTHKEY']}" ]
      task.cucumber_opts <<  '-r features'
    end

    desc "Run cucumber against #{BROWSERS[browser_name]['human']}"
    task browser_name do
      ENV['BROWSER_TASK_NAME'] = browser_name

      Rake::Task["cross_browser:#{browser_name}_run"].execute
    end
  end
end

task :i_say do
  sh 'cucumber'
  puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
  puts "I say tomato, you say #{ENV['tomato']}"
  puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
end