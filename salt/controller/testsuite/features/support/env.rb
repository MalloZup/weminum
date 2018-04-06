require 'English'
require 'rubygems'
require 'tmpdir'
require 'yaml'
require 'base64'
require 'capybara'
require 'capybara/cucumber'
require 'simplecov'
require 'minitest/unit'
require 'securerandom'
require 'selenium-webdriver'

## codecoverage gem
SimpleCov.start
target = YAML.load_file('targets.yml')
server = target['server']

# maximal wait before giving up
# the tests return much before that delay in case of success
$stdout.sync = true
Capybara.default_wait_time = 10

def enable_assertions
  # include assertion globally
  World(MiniTest::Assertions)
end

# register chromedriver headless mode
Capybara.register_driver(:headless_chrome) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu window-size=1920,1080 no-sandbox] }
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities
  )
end
Capybara.default_driver = :headless_chrome
Capybara.javascript_driver = :headless_chrome
Capybara.app_host = "https://#{server}"

# embed a screenshot after each failed scenario
After do |scenario|
  if scenario.failed?
    img_name = "#{SecureRandom.urlsafe_base64}.png"
    save_screenshot(img_name)
    encoded_img = Base64.encode64(File.read(img_name))
    FileUtils.rm_rf(img_name)
    # embedding the base64 image in a cucumber html report
    embed("data:image/png;base64,#{encoded_img}", 'image/png')
  end
end
