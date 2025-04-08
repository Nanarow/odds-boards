require "rails_helper"

RSpec.feature "Board creation", type: :system, js: true do
  context "When the user is logged in" do
    given!(:user) { create(:user) }
    given!(:categories) do
      [
        create(:category, name: "Sport"),
        create(:category, name: "Entertainment"),
        create(:category, name: "Music"),
        create(:category, name: "News")
      ]
    end
    given!(:tags) do
      [
        create(:tag, name: "Trending"),
        create(:tag, name: "Popular"),
        create(:tag, name: "New"),
        create(:tag, name: "Hot")
      ]
    end

    background do
      login_as(user, scope: :user)
    end

    scenario "Successfully creates a board with title and body" do
      visit root_path

      click_on "new-board-button"

      fill_in "board-title", with: "My Board Title"
      fill_in "board-body", with: "My Board Body"

      click_on "publish-board-button"

      expect(page).to have_content "My Board Title"
      expect(page).to have_content "My Board Body"
    end

    scenario "Successfully creates a board with private visibility" do
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

    scenario "Successfully creates a board with public visibility" do
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

    scenario "Successfully creates a board with category" do
      visit root_path

      click_on "new-board-button"

      fill_in "board-title", with: "My Board Title"
      fill_in "board-body", with: "My Board Body"
      select "board-category", with: "Sport"

      click_on "publish-board-button"

      expect(page).to have_content "My Board Title"
      expect(page).to have_content "My Board Body"
    end

    scenario "Successfully creates a board with tags" do
      visit root_path

      click_on "new-board-button"

      fill_in "board-title", with: "My Board Title"
      fill_in "board-body", with: "My Board Body"
      select "board-tags", with: [ "Trending", "Popular" ], multiple: true

      click_on "publish-board-button"

      expect(page).to have_content "My Board Title"
      expect(page).to have_content "My Board Body"
      expect(page).to have_content "Trending"
      expect(page).to have_content "Popular"
    end
  end

  context "When user is not logged in" do
    scenario "Cannot create a board when not logged in" do
      visit root_path

      expect(page).to_not have("new-board-button")
    end
  end
end
