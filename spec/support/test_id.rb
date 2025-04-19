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
  end

  def have(testid)
    have_css("[data-testid='#{testid}']")
  end

  def select(testid, with:)
    click_on testid
    trigger_render

    options = Array(with)
    options.each do |option|
      page.click_on option
    end
    trigger_render
    page.execute_script("document.body.click()")
    trigger_render
  end

  def trigger_render
    page.save_screenshot("tmp/screenshot.png")
  end

  def trigger_render_after(time = 0)
    sleep(time)
    trigger_render
  end
end

RSpec.configure do |config|
  config.include TestIdHelper, type: :system
end
