require 'spec_helper'

feature 'user sets project permissions', %Q{
  As a project creator
  I want to specify users who can view my project(s)
  So that I can keep sensitive materials private
} do

  # Acceptance Criteria
  #
  # permissions option is present for each project
  # user specifies list of email addresses to grant access
  # users on permission list can access project when authenticated
  # users not on permission list are denied access
  # project settings only accessible by project creator

  scenario 'project creator adds collaborator to project' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    creator = membership.user
    project = membership.project
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: creator.email
    fill_in 'Password', with: creator.password
    click_button 'Sign In'
    visit project_path(project)

    click_link 'Add User to Project'
    fill_in 'New User Email', with: 'newbie@example.com'
    choose 'Collaborator'
    click_button 'Create User'

    expect(page).to have_content("New user was successfully added to project.")
  end

  scenario 'non-creator adds user to project'

  scenario 'authenticated collaborator views associated project'

  scenario 'owner changes permission for a member'

  scenario 'owner deletes a member'

  scenario 'authenticated user views unassociated project' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    user = FactoryGirl.create(:user)
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'
    visit project_path(membership.project)
    expect(page).to have_content 'Access Denied.'
  end

end
