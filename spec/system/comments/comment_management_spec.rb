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
        click_on "edit-comment-#{comment.id}-button"
        fill_in "comment-#{comment.id}-input", with: 'Updated Comment'
        click_on "submit-comment-#{comment.id}-button"
        expect(page).to have_content('Updated Comment')
        expect(page).to have_content('Comment was successfully updated.')
      end

      scenario "deletes their own comment" do
        click_on "delete-comment-#{comment.id}-button"
        click_on "confirm-delete-comment-#{comment.id}-button"
        expect(page).to_not have_content("My Comment")
        expect(page).to have_content("Comment was successfully deleted.")
      end

      scenario "cannot edit another user's comment" do
        expect(page).not_to have("edit-comment-#{other_comment.id}-button")
      end

      scenario "cannot delete another user's comment" do
        expect(page).not_to have("delete-comment-#{other_comment.id}-button")
      end
    end

    context "when the user is not logged in" do
      background do
        visit board_path(board)
      end

      scenario "cannot edit a comment" do
        expect(page).not_to have("edit-comment-#{comment.id}-button")
      end

      scenario "cannot delete a comment" do
        expect(page).not_to have("delete-comment-#{comment.id}-button")
      end
    end
  end
end
