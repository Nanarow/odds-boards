require 'rails_helper'

RSpec.feature "Authentication / User Logout", type: :system, js: true do
  describe "logging out" do
    given!(:user) { create(:user) }

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit root_path
      end

      scenario "logs out successfully" do
        pending "Implement: Use click_on 'logout-button'; expect have('login-form') and not have('user-profile')"
      end

      scenario "cannot access protected pages after logout" do
        pending "Implement: Use click_on 'logout-button'; visit new_board_path; expect have('login-form')"
      end
    end
  end
end
