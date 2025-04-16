module TestIdHelper
  def find(testid)
    super("[data-testid='#{testid}']")
  end

  def fill_in(testid, **options)
    find(testid).fill_in(**options)
  end

  def click_on(testid)
    find(testid).click
  end

  def have(testid)
    have_css("[data-testid='#{testid}']")
  end

  def select(testid, with:)
    click_on testid
    page.save_screenshot("tmp/screenshot.png")

    options = Array(with)
    options.each do |option|
      page.click_on option
    end
    page.save_screenshot("tmp/screenshot.png")
    page.execute_script("document.body.click()")
    page.save_screenshot("tmp/screenshot.png")
  end

  def ensure_js_is_ready
    expect(page).to have_css('[data-js-loaded-value="true"]')
  end
end

RSpec.configure do |config|
  config.include TestIdHelper, type: :system
end
