require 'selenium/webdriver'
require 'capybara'
require 'capybara/cucumber'
require 'capybara/rspec'
require 'cucumber'
require 'rspec'


def local_test?
  ENV.has_key? 'tomato'
end

def remote_browser?
  ENV.has_key? 'BROWSER_TASK_NAME'
end

if remote_browser?
  # BROWSERSTACK Multiple browsers and devices

  raise 'Please ensure you supply ENV variables BS_USERNAME and BS_AUTHKEY from browser stack' if !ENV['BS_USERNAME'] || !ENV['BS_AUTHKEY']

  url = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub.browserstack.com/wd/hub"

  # load browser configuration
  browser_data = JSON.load(open('browsers.json'))
  browser_name = ENV['BROWSER_TASK_NAME']
  browser = browser_data[browser_name]

  puts "Testing in #{browser['human']} (#{ENV['BROWSER_TASK_NAME']})..."

  # translate into Selenium Capabilities
  capabilities = Selenium::WebDriver::Remote::Capabilities.new

  # Basic specifications for browser testing
  capabilities["name"] = "FOVe Testing"
  capabilities["os"] = browser["os"]
  capabilities["os_version"] = browser["os_version"]
  capabilities["browser"] = browser["browser"]
  capabilities["browser_version"] = browser["browser_version"]
  capabilities['browserstack.debug'] = true
  capabilities['takesScreenshot'] = true

  # Mobile specifications
  capabilities['browserName'] = browser["browserName"]
  capabilities['platform'] = browser["platform"]
  capabilities['device'] = browser["device"]

  if ENV['BS_AUTOMATE_OS']
    capabilities['os'] = ENV['BS_AUTOMATE_OS']
    capabilities['os_version'] = ENV['BS_AUTOMATE_OS_VERSION']
  else
    capabilities['platform'] = 'MAC'
  end

  browser = Selenium::WebDriver.for(:remote,
  :url => url,
  :desired_capabilities => capabilities)

  Before do |scenario|
    @browser = browser
  end

  at_exit do
    browser.quit
  end


elsif local_test?

  # Local testing with Selenium IDE Firefox Plugin

  driver = Selenium::WebDriver.for :firefox

  Before do |scenario|
    @browser = driver
  end

  at_exit do
    driver.quit
  end

else
  puts "Aw shucks, your command didn't work"
end