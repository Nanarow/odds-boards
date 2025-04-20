module TestIdHelper
  def find_all(testid)
    super("[data-testid='#{testid}']")
  end

  def find(testid)
    super("[data-testid='#{testid}']")
  end

  def fill_in(testid, **options)
    find(testid).fill_in(**options)
  end

  def click_on(testid)
    find(testid).click
    trigger_render if is_headless?
    sleep 0.1 unless is_headless?
  end

  def have(testid)
    have_css("[data-testid='#{testid}']")
  end

  def select(testid, with:)
    click_on testid

    options = Array(with)
    options.each do |option|
      page.click_on option
    end
    trigger_render if is_headless?

    click_outside
  end

  def click_outside
    page.execute_script("document.body.click()")
    trigger_render if is_headless?
    sleep 0.1 unless is_headless?
  end

  def trigger_render
    page.save_screenshot("tmp/screenshot.png")
  end

  def is_headless?
    Capybara.current_driver == :selenium_chrome_headless
  end
end

RSpec.configure do |config|
  config.include TestIdHelper, type: :system
end
