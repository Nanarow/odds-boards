require 'rails_helper'

RSpec.feature "Comments / Creation", type: :system, js: true do
  describe "creating comments" do
    given!(:user) { create(:user) }
    given!(:board) { create(:board, author: user, state: :is_published) }

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit board_path(board)
      end

      scenario "posts a comment on a board" do
        pending "Implement: Use fill_in 'comment-input', with: 'Great board!'; click_on 'comment-submit'; expect have('comment') with 'Great board!'"
      end

      scenario "attempts to post an empty comment" do
        pending "Implement: Use click_on 'comment-submit'; expect have('error-message') with validation error"
      end

      scenario "appends new comment dynamically via Turbo Stream" do
        pending "Implement: Use fill_in 'comment-input', with: 'Great board!'; click_on 'comment-submit'; expect have('comment') appended without reload"
      end
    end

    context "when the user is not logged in" do
      background do
        visit board_path(board)
      end

      scenario "cannot post a comment" do
        pending "Implement: Expect not to have('comment-input'); expect have('login-prompt') after attempting to comment"
      end
    end
  end
end
