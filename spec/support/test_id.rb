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

  def select(testid, with:, multiple: false)
    click_on testid
    if multiple
      with.each { |option| page.click_on option }
    else
      page.click_on with
    end
  end
end

RSpec.configure do |config|
  config.include TestIdHelper, type: :feature
end
