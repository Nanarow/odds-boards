require 'rails_helper'

RSpec.feature "Application / Navigation", type: :system, js: true do
  describe "navigating the application" do
    given!(:user) { create(:user) }
    given!(:board) { create(:board, author: user, state: :is_published) }

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit root_path
      end

      scenario "navigates to board index" do
        pending "Implement: Use click_on 'boards-link'; expect have('search-results')"
      end

      scenario "navigates back from board show page" do
        pending "Implement: Visit board_path(board); click_on 'back-button'; expect have('search-results')"
      end

      scenario "navigates to board show page" do
        pending "Implement: Use click_on 'board-title'; expect have('board')"
      end

      scenario "handles back button dynamically via Turbo Stream" do
        pending "Implement: Visit board_path(board); click_on 'back-button'; expect have('search-results') without reload"
      end
    end
  end
end
