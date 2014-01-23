require 'spec_helper'

feature 'user signs out', %Q{
  As a user
  I want to sign out
  So that my account is not accessible
} do

  # Acceptance Criteria
  # While signed in, I can sign out to end my user session

  scenario 'authenticated user signs out' do
    user = FactoryGirl.create(:user)
    visit new_user_session_path
    within '.sign_in' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign In'
    end

    expect(page).to have_content('Sign Out')
    click_link 'Sign Out'

    expect(page).to have_content('Signed out successfully.')
  end

end
