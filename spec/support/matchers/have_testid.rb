RSpec::Matchers.define :have_testid do |testid|
  match do |page|
    page.has_selector?("[data-testid='#{testid}']")
  end

  failure_message do |page|
    "expected page to have element with data-testid='#{testid}', but it was not found"
  end

  failure_message_when_negated do |page|
    "expected page NOT to have element with data-testid='#{testid}', but it was found"
  end
end
