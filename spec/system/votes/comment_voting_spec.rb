require 'rails_helper'

RSpec.feature "Votes / Comment Voting", type: :system, js: true do
  describe "voting on comments" do
    given!(:user) { create(:user) }
    given!(:other_user) { create(:user) }
    given!(:board) { create(:board, author: other_user, state: :is_published) }
    given!(:comment) { create(:comment, commenter: other_user, board: board) }
    given!(:own_comment) { create(:comment, commenter: user, board: board) }

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit board_path(board)
      end

      scenario "can vote on their own comment" do
        click_on "comment-#{own_comment.id}-upvote-button"
        expect(page).to have_content("1 upvotes")
      end

      scenario "can vote on another user's comment" do
        click_on "comment-#{comment.id}-upvote-button"
        expect(page).to have_content("1 upvotes")
      end

      scenario "unvotes a comment" do
        click_on "comment-#{comment.id}-upvote-button"

        expect(page).to have_content("1 upvotes")

        click_on "comment-#{comment.id}-upvote-button"

        expect(page).to have_content("0 upvotes")
      end
    end
  end
end
