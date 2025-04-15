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


RSpec.configure do |config|
  driver = (ENV['CAPYBARA_DRIVER'] || :selenium_chrome).to_sym
  config.before(:each, type: :system) do
    driven_by driver
  end

  config.before(:each, type: :system, js: true) do
    driven_by driver
  end
end
