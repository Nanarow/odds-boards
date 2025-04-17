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

      scenario "upvotes a comment" do
        pending "Implement: Use click_on 'comment-upvote-button'; expect have('comment-vote-count') with text '1'"
      end

      scenario "downvotes a comment" do
        pending "Implement: Use click_on 'comment-downvote-button'; expect have('comment-vote-count') with text '-1'"
      end

      scenario "cannot vote on their own comment" do
        pending "Implement: Visit board with own comment; expect not to have('comment-upvote-button') or have('vote-error') on vote attempt"
      end

      scenario "updates comment vote count dynamically via Turbo Stream" do
        pending "Implement: Use click_on 'comment-upvote-button'; expect have('comment-vote-count') with updated count without reload"
      end
    end

    context "when the user is not logged in" do
      background do
        visit board_path(board)
      end

      scenario "cannot vote on a comment" do
        pending "Implement: Expect not to have('comment-upvote-button'); expect have('login-prompt') after attempting to vote"
      end
    end
  end
end
