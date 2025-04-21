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
        fill_in 'comment-input', with: 'Great board!'
        click_on 'submit-comment-button'
        expect(page).to have_content('Great board!')
        expect(page).to have_content('Comment was successfully created.')
      end

      scenario "fails to post blank comment" do
        fill_in 'comment-input', with: ''
        click_on 'submit-comment-button'
        expect(page).to have_content("Comment can't be blank")
      end
    end
  end
end
