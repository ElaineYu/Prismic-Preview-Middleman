# If you do not have OpenSSL installed, update
# the following line to use "http://" instead
source 'https://rubygems.org'

gem "middleman", "~>3.3.7"

# Live-reloading plugin
gem "middleman-livereload", "~> 3.1.0"

# For faster file watcher updates on Windows:
gem "wdm", "~> 0.1.0", :platforms => [:mswin, :mingw]

# Windows does not come with time zone data
gem "tzinfo-data", platforms: [:mswin, :mingw]

# Boostrap SASS
gem "bootstrap-sass", :require => false

# Automatically add vendor prefixes to CSS rules in stylesheets
gem 'middleman-autoprefixer'

# Adds JQuery (for now until AngularJS is here)
gem "jquery-middleman"

# AWS S3 Bucket
gem 'middleman-s3_sync'

# AWS Cloudfront cache invalidation
gem "middleman-cloudfront"

# For specifying multiple browsers for testing, browsers.json
gem 'json'

# Ruby prismic
gem 'prismic.io', require: 'prismic'

group :development do
  gem "rake"
  gem "rspec"
  gem "capybara"
  gem "rspec-expectations"
  gem "selenium-webdriver"
  gem 'cucumber'
end