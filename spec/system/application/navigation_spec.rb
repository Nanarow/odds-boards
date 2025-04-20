require 'rails_helper'

RSpec.feature "Application / Navigation", type: :system do
  describe "navigating the application" do
    given!(:user) { create(:user) }
    given!(:other_user) { create(:user) }
    given!(:board) { create(:board, title: "My Board", author: user, state: :is_published) }
    given!(:other_board) { create(:board, title: "Other Board", author: other_user, state: :is_published) }

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit root_path
      end

      scenario "navigates to my boards page" do
        click_on "my-boards-link"

        expect(page).to have_content("My Boards")
        expect(page).to_not have_content("Other Board")
      end

      scenario "navigates to board show page" do
        click_on "board-#{board.id}"

        expect(page).to have_content("My Board")
        expect(page).to_not have_content("Other Board")
        expect(page).to have_content("Back")
      end

      scenario "navigates back from board show page" do
        click_on "board-#{board.id}"

        expect(page).to have_content("My Board")
        expect(page).to_not have_content("Other Board")
        expect(page).to have_content("Back")

        click_on "back-button"

        expect(page).to have_content("My Boards")
        expect(page).to have_content("Other Board")
        expect(page).to_not have_content("Back")
      end
    end
  end
end
