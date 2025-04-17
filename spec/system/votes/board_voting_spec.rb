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
        visit board_path(board)
      end

      scenario "upvotes a board" do
        pending "Implement: Use click_on 'upvote-button'; expect have('vote-count') with text '1'"
      end

      scenario "downvotes a board" do
        pending "Implement: Use click_on 'downvote-button'; expect have('vote-count') with text '-1'"
      end

      scenario "changes vote from upvote to downvote" do
        pending "Implement: Use click_on 'upvote-button'; click_on 'downvote-button'; expect have('vote-count') with text '-1'"
      end

      scenario "cannot vote on their own board" do
        pending "Implement: Visit own board; expect not to have('upvote-button') or have('vote-error') on click"
      end

      scenario "updates board vote count dynamically via Turbo Stream" do
        pending "Implement: Use click_on 'upvote-button'; expect have('vote-count') with updated count without reload"
      end
    end

    context "when the user is not logged in" do
      background do
        visit board_path(board)
      end

      scenario "cannot vote on a board" do
        pending "Implement: Expect not to have('upvote-button'); expect have('login-prompt') after attempting to vote"
      end
    end
  end
end
