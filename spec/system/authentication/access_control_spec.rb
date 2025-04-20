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
        click_on "board-#{board.id}"
        fill_in 'comment-input', with: 'Great board!'
        click_on 'submit-comment-button'

        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end

      scenario "cannot vote a board" do
        click_on "board-#{board.id}-upvote-button"

        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end

      scenario "cannot vote a comment" do
        click_on "board-#{board.id}"
        click_on "comment-#{comment.id}-upvote-button"
        expect(page).to have_content('You need to sign in or sign up before continuing.')
      end
    end
  end
end
