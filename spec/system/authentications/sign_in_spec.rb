require 'rails_helper'

RSpec.feature "Signing in", type: :system do
    background do
      create(:user)
    end

    scenario "Signing in with correct credentials" do
      visit new_user_session_path

      fill_in 'email', with: 'user1@example.com'
      fill_in 'password', with: 'password'

      click_on 'sign-in-button'

      notification = find('notification')
      expect(notification).to be_visible
      expect(notification).to have_content 'Signed in successfully.'
    end

    scenario "Signing in as another user with wrong password" do
      visit new_user_session_path

      fill_in 'email', with: 'user1@example.com'
      fill_in 'password', with: 'wrong-password'

      click_on 'sign-in-button'

      alert_notification = find('alert-notification')
      expect(alert_notification).to be_visible
      expect(alert_notification).to have_content 'Invalid username or email or password.'
    end
end
