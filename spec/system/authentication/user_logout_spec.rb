require 'rails_helper'

RSpec.feature "Authentication / User Logout", type: :system do
  describe "logging out" do
    given!(:user) { create(:user) }

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit root_path
      end

      scenario "logs out successfully" do
        click_on 'logout-button'
        expect(page).to have_content("Login")
        expect(page).to have_content("Signed out successfully.")
      end

      scenario "cannot access protected pages after logout" do
        click_on 'logout-button'
        click_on 'my-boards-link'
        expect(page).to have_content("Log in")
        expect(page).to have_content("You need to sign in or sign up before continuing.")
      end
    end
  end
end
