require 'rails_helper'

RSpec.feature "Signing up", type: :feature do
  scenario "Signing up with correct credentials" do
    visit new_user_registration_path

    fill_in 'email', with: 'user1@example.com'
    fill_in 'username', with: 'user1'
    fill_in 'password', with: 'password'
    fill_in 'password_confirmation', with: 'password'

    click_on 'sign-up-button'

    notification = find('notification')
    expect(notification).to be_visible
    expect(notification).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario "Signing up with wrong credentials" do
    visit new_user_registration_path

    fill_in 'email', with: 'user1@example.com'
    fill_in 'username', with: 'user1'
    fill_in 'password', with: 'password'
    fill_in 'password_confirmation', with: 'wrong-password'

    click_on 'sign-up-button'

    form = find('sign-up-form')
    expect(form).to have_content 'Password confirmation doesn\'t match Password'
  end

  scenario "Signing up with short password" do
    visit new_user_registration_path

    fill_in 'email', with: 'user1@example.com'
    fill_in 'username', with: 'user1'
    fill_in 'password', with: 'pass'
    fill_in 'password_confirmation', with: 'pass'

    click_on 'sign-up-button'

    form = find('sign-up-form')
    expect(form).to have_content 'Password is too short (minimum is 6 characters)'
  end
end
