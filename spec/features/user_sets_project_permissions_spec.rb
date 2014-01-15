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

  scenario 'user views project members'

  scenario 'project creator adds collaborator to project' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    email = 'newbie@example.com'
    new_member = FactoryGirl.create(:user, email: email)
    creator = membership.user
    project = membership.project
    sign_in_as(creator)
    visit project_path(project)

    click_link 'Add New Member'
    fill_in 'User Email', with: email
    click_button 'Create User'

    expect(page).to have_content('New user was successfully added to project.')
    expect(project.users).to include(new_member)
  end

  scenario 'creator adds self to project, receives errors' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    creator = membership.user
    project = membership.project
    sign_in_as(creator)
    visit project_path(project)

    click_link 'Add New Member'
    fill_in 'User Email', with: creator.email
    click_button 'Create User'

    expect(page).to have_content('membership already exists.')
  end

  scenario 'creator adds existing relationship, receives errors'

  scenario 'non-creator adds user to project'

  scenario 'authenticated collaborator views associated project'

  scenario 'owner changes permission for a member' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    email = 'newbie@example.com'
    new_member = FactoryGirl.create(:user, email: email)
    creator = membership.user
    project = membership.project
    sign_in_as(creator)
    visit project_path(project)

    click_link 'Add New Member'
    fill_in 'User Email', with: email
    choose 'collaborator'
    click_button 'Create User'
    expect(page).to have_content('New user was successfully added to project.')

    within "#user_#{new_member.id}" do
      click_link 'Edit Role'
    end
    choose 'creator'
    click_button 'Update Role'

    expect(page).to have_content('User has been updated.')
    within "#user_#{new_member.id}" do
      expect(page).to have_content('creator')
    end
  end

  scenario 'owner deletes a member' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    email = 'newbie@example.com'
    new_member = FactoryGirl.create(:user, email: email)
    creator = membership.user
    project = membership.project
    sign_in_as(creator)
    visit project_path(project)

    click_link 'Add New Member'
    fill_in 'User Email', with: email
    choose 'collaborator'
    click_button 'Create User'

    visit project_path(project)
    within "#user_#{new_member.id}" do
      click_link 'Remove User'
    end

    expect(page).to have_content('User has been removed from this project')
    expect(page).to_not have_content(email)
  end

  scenario 'authenticated user views unassociated project' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    user = FactoryGirl.create(:user)
    sign_in_as(user)
    visit project_path(membership.project)
    expect(page).to have_content 'Access Denied.'
  end

end
