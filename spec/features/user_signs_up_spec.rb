require 'spec_helper'

feature 'user registers for site', %Q{
  As an unregistered user
  I want to register for the site
  So that I may share and comment on videos
} do

  # Acceptable Criteria
  # registration requires name, email address, password
  # email address must be unique
  # error message displayed if fields left blank
  # error message displayed if passwords do not match
  # with required information specified, access granted to welcome page

  scenario 'specifying valid and required information' do
    visit root_path
    click_link 'Sign Up'
    fill_in 'First Name', with: 'Don'
    fill_in 'Last Name', with: 'Draper'
    fill_in 'Email', with: 'dondraper@sterlingcooper.com'
    fill_in 'Password', with: 'password', match: :prefer_exact
    fill_in 'Password Confirmation', with: 'password', match: :prefer_exact
    click_button 'Sign up'

    expect(page).to have_content("You've been registered.")
    expect(page).to have_content('Sign Out')
  end

  scenario 'required information is not supplied' do
    visit root_path
    click_link 'Sign Up'
    click_button 'Sign up'

    expect(page).to have_content("can't be blank")
    expect(page).to_not have_content("Sign Out")
  end

  scenario 'password confirmation does not match password' do
    visit root_path
    click_link 'Sign Up'

    fill_in 'user_password', with: 'password'
    fill_in 'Password Confirmation', with: 'somethingDifferent'

    click_button 'Sign up'

    expect(page).to have_content("doesn't match")
    expect(page).to_not have_content("Sign Out")
  end

end
