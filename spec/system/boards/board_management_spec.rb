require 'rails_helper'

RSpec.feature "Boards / Management", type: :system, js: true do
  describe "managing boards" do
    given!(:user) { create(:user) }
    given!(:other_user) { create(:user) }
    given!(:board) { create(:board, author: user, title: "My Board", state: :is_published) }
    given!(:other_board) { create(:board, author: other_user, title: "Other Board", state: :is_published) }

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit board_path(board)
      end

      scenario "updates their own board" do
        pending "Implement: Use click_on 'board-edit-link'; fill_in 'board-title', with: 'Updated Title'; click_on 'board-submit'; expect have('board-title') with 'Updated Title'"
      end

      scenario "deletes their own board" do
        pending "Implement: Use click_on 'board-delete'; expect page not to have('board-title') with 'My Board'"
      end

      scenario "cannot edit another user's board" do
        pending "Implement: Visit other board; expect not to have('board-edit-link') or have('access-denied') on edit attempt"
      end

      scenario "cannot delete another user's board" do
        pending "Implement: Visit other board; expect not to have('board-delete') or have('access-denied') on delete attempt"
      end
    end
  end
end
