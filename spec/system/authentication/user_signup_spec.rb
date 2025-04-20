require 'rails_helper'

RSpec.feature "Authentication / User Signup", type: :system do
  describe "signing up" do
    context "when the user does not have an account" do
      background do
        visit new_user_registration_path
      end

      scenario "signs up with valid details" do
        fill_in 'email', with: 'user1@example.com'
        fill_in 'username', with: 'user1'
        fill_in 'password', with: 'password'
        fill_in 'password_confirmation', with: 'password'

        click_on 'sign-up-button'

        notification = find('notification')
        expect(notification).to be_visible
        expect(notification).to have_content 'Welcome! You have signed up successfully.'
      end

      scenario "fails to sign up with mismatched passwords" do
        fill_in 'email', with: 'user1@example.com'
        fill_in 'username', with: 'user1'
        fill_in 'password', with: 'password'
        fill_in 'password_confirmation', with: 'wrong-password'

        click_on 'sign-up-button'

        form = find('sign-up-form')
        expect(form).to have_content 'Password confirmation doesn\'t match Password'
      end

      scenario "fails to sign up with too short password" do
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

    context "when the user already has an account" do
      background do
        create(:user, email: "user1@example.com", username: "user1", password: "password")
        visit new_user_registration_path
      end

      scenario "fails to sign up with existing email" do
        fill_in 'email', with: 'user1@example.com'
        fill_in 'username', with: 'user1'
        fill_in 'password', with: 'password'
        fill_in 'password_confirmation', with: 'pass'

        click_on 'sign-up-button'

        form = find('sign-up-form')
        expect(form).to have_content 'Email has already been taken'
      end

      scenario "fails to sign up with existing username" do
        fill_in 'email', with: 'user2@example.com'
        fill_in 'username', with: 'user1'
        fill_in 'password', with: 'password'
        fill_in 'password_confirmation', with: 'password'
        click_on 'sign-up-button'

        form = find('sign-up-form')
        expect(form).to have_content 'Username has already been taken'
      end
    end
  end
end
