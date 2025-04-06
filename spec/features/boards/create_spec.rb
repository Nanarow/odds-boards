require "rails_helper"

RSpec.feature "Creating a board", type: :feature, js: true do
  context "When user is logged in" do
    given!(:user) { create(:user) }
    given!(:categories) { create_list(:category, 4) }

    background do
      login_as(user, scope: :user)
    end

    scenario "Creating a board successfully" do
      visit root_path

      click_on "new-board-button"

      fill_in "board-title", with: "My Board Title"
      fill_in "board-body", with: "My Board Body"

      click_on "publish-board-button"

      expect(page).to have_content "My Board Title"
      expect(page).to have_content "My Board Body"
    end

    scenario "Creating a board successfully with category" do
      visit root_path

      click_on "new-board-button"

      fill_in "board-title", with: "My Board Title"
      fill_in "board-body", with: "My Board Body"
      select "board-category", with: categories.first.name

      click_on "publish-board-button"

      expect(page).to have_content "My Board Title"
      expect(page).to have_content "My Board Body"
      expect(page).to have_content categories.first.name
    end

    scenario "Creating a board successfully with visibility private" do
      visit root_path

      click_on "new-board-button"

      fill_in "board-title", with: "My Board Title"
      fill_in "board-body", with: "My Board Body"
      select "board-visibility", with: "Private"

      click_on "publish-board-button"

      expect(page).to have_content "My Board Title"
      expect(page).to have_content "My Board Body"

      click_on "logout-button"

      expect(page).to_not have_content "My Board Title"
      expect(page).to_not have_content "My Board Body"
    end

    scenario "Creating a board successfully with visibility public" do
      visit root_path

      click_on "new-board-button"

      fill_in "board-title", with: "My Board Title"
      fill_in "board-body", with: "My Board Body"
      select "board-visibility", with: "Public"

      click_on "publish-board-button"

      expect(page).to have_content "My Board Title"
      expect(page).to have_content "My Board Body"

      click_on "logout-button"

      expect(page).to have_content "My Board Title"
      expect(page).to have_content "My Board Body"
    end

    scenario "Creating a board successfully with tags" do
      visit root_path

      click_on "new-board-button"

      fill_in "board-title", with: "My Board Title"
      fill_in "board-body", with: "My Board Body"
      select "board-tags", with: [ "Tag 1", "Tag 2" ], multiple: true

      click_on "publish-board-button"

      expect(page).to have_content "My Board Title"
      expect(page).to have_content "My Board Body"
      expect(page).to have_content "Tag 1"
      expect(page).to have_content "Tag 2"
    end
  end

  context "When user is not logged in" do
    scenario "Cannot create a board when not logged in" do
      visit root_path

      expect(page).to_not have("new-board-button")
    end
  end
end
