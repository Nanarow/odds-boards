require 'rails_helper'

RSpec.feature "Votes / Board Voting", type: :system, js: true do
  describe "voting on boards" do
    given!(:user) { create(:user) }
    given!(:other_user) { create(:user) }
    given!(:board) { create(:board, author: other_user, state: :is_published) }
    given!(:own_board) { create(:board, author: user, state: :is_published) }

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit boards_path
      end

      scenario "can vote on their own board" do
        click_on "board-#{own_board.id}-upvote-button"
        expect(page).to have_content("1 upvotes")
      end

      scenario "can vote on another user's board" do
        click_on "board-#{board.id}-upvote-button"
        expect(page).to have_content("1 upvotes")
      end

      scenario "unvotes a board" do
        click_on "board-#{board.id}-upvote-button"

        expect(page).to have_content("1 upvotes")

        click_on "board-#{board.id}-upvote-button"

        expect(page).to have_content("0 upvotes")
      end
    end
  end
end
