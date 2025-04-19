require 'rails_helper'

RSpec.feature "Authentication / User Login", type: :system do
  describe "logging in" do
    given!(:user) { create(:user, email: "test@example.com", password: "password123") }

    context "when the user provides credentials" do
      background do
        visit new_user_session_path
      end

      scenario "logs in with valid credentials" do
        fill_in 'email', with: 'test@example.com'
        fill_in 'password', with: 'password123'

        click_on 'sign-in-button'

        notification = find('notification')
        expect(notification).to be_visible
        expect(notification).to have_content 'Signed in successfully.'
      end

      scenario "fails to log in with invalid password" do
        visit new_user_session_path

        fill_in 'email', with: 'user1@example.com'
        fill_in 'password', with: 'wrong-password'

        click_on 'sign-in-button'

        notification = find('notification')
        expect(notification).to be_visible
        expect(notification).to have_content 'Invalid username or email or password.'
      end

      scenario "fails to log in with non-existent email" do
        fill_in 'email', with: 'unknown@example.com'
        fill_in 'password', with: 'password123'

        click_on 'sign-in-button'

        notification = find('notification')
        expect(notification).to be_visible
        expect(notification).to have_content 'Invalid username or email or password.'
      end
    end
  end
end
