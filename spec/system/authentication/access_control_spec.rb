require 'rails_helper'

RSpec.feature "Authentication / Access Control", type: :system, js: true do
  describe "restricting access" do
    given!(:user) { create(:user) }
    given!(:other_user) { create(:user) }
    given!(:board) { create(:board, author: user, state: :is_published) }
    given!(:comment) { create(:comment, commenter: user, board: board) }

    context "when the user is not logged in" do
      background do
        visit root_path
      end

      scenario "cannot create a board" do
        expect(page).not_to have("new-board-button")
      end

      scenario "cannot comment" do
        click_on "board-title"
        fill_in 'comment-input', with: 'Great board!'
        click_on 'submit-comment-button'
        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end

      scenario "cannot vote" do
        pending "Implement: Visit board_path(board); expect not to have('upvote-button'); expect have('login-prompt') after attempting to vote"
      end
    end

    context "when the user is logged in" do
      background do
        login_as(other_user, scope: :user)
        visit board_path(board)
      end

      scenario "cannot manage another user's board" do
        pending "Implement: Expect not to have('board-edit-link') or have('access-denied') on edit/delete attempt"
      end

      scenario "cannot manage another user's comment" do
        pending "Implement: Expect not to have('comment-edit-link') or have('access-denied') on edit/delete attempt"
      end
    end
  end
end
