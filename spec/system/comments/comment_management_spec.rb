require 'rails_helper'

RSpec.feature "Comments / Management", type: :system, js: true do
  describe "managing comments" do
    given!(:user) { create(:user) }
    given!(:other_user) { create(:user) }
    given!(:board) { create(:board, author: user, state: :is_published) }
    given!(:comment) { create(:comment, commenter: user, board: board, body: "My Comment") }
    given!(:other_comment) { create(:comment, commenter: other_user, board: board, body: "Other Comment") }

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit board_path(board)
      end

      scenario "edits their own comment" do
        pending "Implement: Use click_on 'comment-edit-link'; fill_in 'comment-input', with: 'Updated Comment'; click_on 'comment-submit'; expect have('comment') with 'Updated Comment'"
      end

      scenario "deletes their own comment" do
        pending "Implement: Use click_on 'comment-delete'; expect page not to have('comment') with 'My Comment'"
      end

      scenario "cannot edit another user's comment" do
        pending "Implement: Visit board with other comment; expect not to have('comment-edit-link') or have('access-denied') on edit attempt"
      end

      scenario "cannot delete another user's comment" do
        pending "Implement: Visit board with other comment; expect not to have('comment-delete') or have('access-denied') on delete attempt"
      end

      scenario "updates edited comment dynamically via Turbo Stream" do
        pending "Implement: Use click_on 'comment-edit-link'; fill_in 'comment-input', with: 'Updated'; click_on 'comment-submit'; expect have('comment') with updated content without reload"
      end

      scenario "removes deleted comment dynamically via Turbo Stream" do
        pending "Implement: Use click_on 'comment-delete'; expect page not to have('comment') without reload"
      end
    end
  end
end
