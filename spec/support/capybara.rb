require 'capybara/rspec'

Capybara.server = :puma
Capybara.default_max_wait_time = 2
module SlowCapybara
  SLOW_METHODS = %i[
    find click_button click_link fill_in choose check uncheck select
  ]

  SLOW_METHODS.each do |method_name|
    define_method(method_name) do |*args, **kwargs, &block|
      sleep 0.5
      super(*args, **kwargs, &block)
    end
  end
end

if ENV["SLOW"] == "true"
  Capybara::Session.prepend(SlowCapybara)
end

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--window-size=1280,1280")
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

def set_driver(driver, javascript_driver = driver)
  RSpec.configure do |config|
    config.before(:each, type: :system) do
      driven_by driver
    end
    config.before(:each, type: :system, js: true) do
      driven_by javascript_driver
    end
  end
end

if ENV["HEADLESS_DRIVER"] == "true"
  set_driver :rack_test, :selenium_chrome_headless
else
  set_driver :selenium_chrome
end
