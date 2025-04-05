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
end

RSpec.configure do |config|
  config.include TestIdHelper, type: :feature
end
