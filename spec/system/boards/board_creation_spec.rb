require 'rails_helper'

RSpec.feature "Boards / Creation", type: :system, js: true do
  describe "board creation" do
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

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit root_path
      end

      scenario "successfully creates a board with title and body" do
        click_on "new-board-button"

        fill_in "board-title", with: "My Board Title"
        fill_in "board-body", with: "My Board Body"

        click_on "publish-board-button"

        expect(page).to have_content("My Board Title")
        expect(page).to have_content("My Board Body")
      end

      scenario "successfully creates a board with default private visibility" do
        click_on "new-board-button"

        fill_in "board-title", with: "My Board Title"
        fill_in "board-body", with: "My Board Body"

        click_on "publish-board-button"

        expect(page).to have_content("My Board Title")
        expect(page).to have_content("My Board Body")

        click_on "logout-button"

        expect(page).not_to have_content("My Board Title")
        expect(page).not_to have_content("My Board Body")
      end

      scenario "successfully creates a board with public visibility" do
        click_on "new-board-button"

        fill_in "board-title", with: "My Board Title"
        fill_in "board-body", with: "My Board Body"
        select "board-visibility", with: "Public"

        click_on "publish-board-button"

        expect(page).to have_content("My Board Title")
        expect(page).to have_content("My Board Body")

        click_on "logout-button"

        expect(page).to have_content("My Board Title")
        expect(page).to have_content("My Board Body")
      end

      scenario "successfully creates a board with category" do
        click_on "new-board-button"

        fill_in "board-title", with: "My Board Title"
        fill_in "board-body", with: "My Board Body"
        select "board-category", with: "Sport"

        click_on "publish-board-button"

        expect(page).to have_content("My Board Title")
        expect(page).to have_content("My Board Body")
        expect(page).to have_content("Sport")
      end

      scenario "successfully creates a board with tags" do
        click_on "new-board-button"

        fill_in "board-title", with: "My Board Title"
        fill_in "board-body", with: "My Board Body"
        select "board-tags", with: [ "Trending", "Popular" ]

        click_on "publish-board-button"

        expect(page).to have_content("My Board Title")
        expect(page).to have_content("My Board Body")
        expect(page).to have_content("Trending")
        expect(page).to have_content("Popular")
      end

      scenario "fails to create a board with missing title" do
        click_on "new-board-button"

        fill_in "board-body", with: "My Board Body"

        click_on "publish-board-button"

        expect(page).to have_content("Title can't be blank")
        expect(page).to have_field('board[body]', with: "My Board Body")
      end

      scenario "fails to create a board with missing body" do
        click_on "new-board-button"

        fill_in "board-title", with: "My Board Title"

        click_on "publish-board-button"

        expect(page).to have_field('board[title]', with: 'My Board Title')
        expect(page).to have_content("Body can't be blank")
      end
    end

    context "when the user is not logged in" do
      background do
        visit root_path
      end

      scenario "cannot create a board" do
        expect(page).not_to have("new-board-button")
      end
    end
  end
end
