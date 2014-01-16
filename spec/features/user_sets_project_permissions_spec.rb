require 'spec_helper'

feature 'user sets project permissions', %Q{
  As a project creator
  I want to specify users who can view my project(s)
  So that I can keep sensitive materials private
} do

  # Acceptance Criteria
  #
  # permissions option is present for each project
  # user enters a registered email address to grant access to that user
  # users on permission list can access project when authenticated
  # users not on permission list are denied access
  # project settings only accessible by project creator

  scenario 'user creates project and views project members' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    creator = membership.user
    project = membership.project
    email = 'newbie@example.com'
    new_member = FactoryGirl.create(:user, email: email)
    FactoryGirl.create(:membership, user_id: new_member.id, project_id: project.id)
    sign_in_as(creator)

    visit project_path(project)
    expect(page).to have_content(new_member.first_name)
    expect(page).to have_content(new_member.last_name)
    expect(page).to have_content(new_member.email)
    expect(page).to have_content('creator')
  end

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

  scenario 'creator adds member, blank form' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    creator = membership.user
    project = membership.project
    sign_in_as(creator)
    visit project_path(project)

    click_link 'Add New Member'
    click_button 'Create User'

    expect(page).to have_content('must match email of a registered user.')
  end

  scenario 'creator submits unregistered email address in add member' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    creator = membership.user
    project = membership.project
    sign_in_as(creator)
    visit project_path(project)

    click_link 'Add New Member'
    fill_in 'User Email', with: 'random@test.com'
    click_button 'Create User'

    expect(page).to have_content('must match email of a registered user.')
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

    expect(page).to have_content('Membership already exists.')
  end

  scenario 'creator adds existing relationship, receives errors' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    creator = membership.user
    project = membership.project
    email = 'newbie@example.com'
    new_member = FactoryGirl.create(:user, email: email)
    FactoryGirl.create(:membership, user_id: new_member.id, project_id: project.id)
    sign_in_as(creator)
    visit project_path(project)

    click_link 'Add New Member'
    fill_in 'User Email', with: new_member.email
    click_button 'Create User'

    expect(page).to have_content('Membership already exists.')
  end

  scenario 'collaborator adds user to project, receives error' do
    membership = FactoryGirl.create(:membership, role: 'collaborator')
    user = membership.user
    project = membership.project
    sign_in_as(user)

    visit project_path(project)
    click_link 'Add New Member'

    expect(page).to have_content('You are not authorized to manage members in this group')
  end

  scenario 'collaborator changes permission, receives error' do
    membership = FactoryGirl.create(:membership, role: 'collaborator')
    user = membership.user
    project = membership.project
    sign_in_as(user)

    visit project_path(project)
    click_link 'Edit Role'
    expect(page).to have_content('You are not authorized to manage members in this group')
  end

  scenario 'collaborator views associated project, denied' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    email = 'newbie@example.com'
    new_member = FactoryGirl.create(:user, email: email)
    creator = membership.user
    project = membership.project

    sign_in_as(new_member)
    visit project_path(project)
    expect(page).to have_content('Access Denied.')
    click_link 'Sign Out'

    sign_in_as(creator)
    visit project_path(project)

    click_link 'Add New Member'
    fill_in 'User Email', with: email
    click_button 'Create User'
    click_link 'Sign Out'

    sign_in_as(new_member)
    visit project_path(project)
    expect(page).to have_content(new_member.email)
  end

  scenario 'creator changes permission for a member' do
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
