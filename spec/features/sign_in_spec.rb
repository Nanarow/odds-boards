require 'rails_helper'

RSpec.feature "Sign in", type: :feature do
    background do
      create(:user)
    end

    scenario "Signing in with correct credentials" do
      visit '/users/login'
      fill_in 'Email', with: 'user1@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      expect(page).to have_content 'Signed in successfully.'
    end

    scenario "Signing in as another user with wrong password" do
      visit '/users/login'
      fill_in 'Email', with: 'user1@example.com'
      fill_in 'Password', with: 'wrong-password'
      click_button 'Log in'
      expect(page).to have_content 'Invalid username or email or password.'
    end
end
