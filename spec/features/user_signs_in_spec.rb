require 'spec_helper'

feature 'user signs in', %Q{
  As a user
  I want to sign in
  So that I can access my projects
} do

  # Acceptance Criteria
  # If I specify a valid, previously registered email and password, I am authenticated
  # and I gain access to the system
  # If I specify an invalid email and password, I remain unauthenticated
  # If I am already signed in, I can't sign in again

  scenario 'an existing user specifies a valid email and password' do
    user = FactoryGirl.create(:user)
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'
    expect(page).to have_content('Welcome back!')
    expect(page).to have_content('Sign Out')
  end
  scenario 'a nonexistant email and password is supplied'
  scenario 'an existing email wiht the wrong password is denied access'
  scenario 'an already authenticated user cannot re-sign in'

end
