require 'rails_helper'

RSpec.feature "Boards / Management", type: :system, js: true do
  describe "managing boards" do
    given!(:user) { create(:user) }
    given!(:other_user) { create(:user) }
    given!(:board) { create(:board, author: user, title: "My Board Title", state: :is_published) }
    given!(:other_board) { create(:board, author: other_user, title: "Other Board", state: :is_published) }

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit root_path
      end

      scenario "updates their own board" do
        click_on "edit-board-#{board.id}-button"

        fill_in "board-title-input", with: 'Updated Title'

        click_on "publish-board-button"

        expect(page).to have_content("Updated Title")
        expect(page).to have_content("Board was successfully updated.")
      end

      scenario "deletes their own board" do
        click_on "delete-board-#{board.id}-button"
        click_on "confirm-delete-board-#{board.id}-button"

        expect(page).to_not have_content("My Board Title")
        expect(page).to have_content("Board was successfully deleted.")
      end

      scenario "cannot edit another user's board" do
        expect(page).to_not have_testid("edit-board-#{other_board.id}-button")
      end

      scenario "cannot delete another user's board" do
        expect(page).to_not have_testid("delete-board-#{other_board.id}-button")
      end
    end

    context "when the user is not logged in" do
      background do
        visit root_path
      end

      scenario "cannot update a board" do
        expect(page).not_to have_testid("edit-board-#{board.id}-button")
      end

      scenario "cannot delete a board" do
        expect(page).not_to have_testid("delete-board-#{board.id}-button")
      end
    end
  end
end
