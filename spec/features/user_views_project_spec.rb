require 'spec_helper'

feature 'user views project', %Q{
  As an authenticated user
  I want to view a project
  So that I can check the status of it
} do

  # Acceptance Criteria
  #
  # user can only view project if their membership is creator or collaborator
  # if no relationship exists, the project page is not displayed
  # all projects are displayed from projects page
  # projects divided by ones you've created and ones you've collaborated on

  scenario 'user views projects index page, sees all projects' do
    creator_membership = FactoryGirl.create(:membership, role: 'creator')
    user = creator_membership.user
    created_project = creator_membership.project
    collaborator_membership = FactoryGirl.create(:membership, user: user, role: 'collaborator')
    collaborated_project = collaborator_membership.project
    sign_in_as(user)

    click_link 'Projects'
    within '.created' do
      expect(page).to have_content(created_project.title)
    end
    within '.collaborated' do
      expect(page).to have_content(collaborated_project.title)
    end
  end

  scenario 'user views project on which they are a creator' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    creator = membership.user
    project = membership.project
    sign_in_as(creator)

    click_link 'Projects'
    within '.created' do
      expect(page).to have_content(project.title)
    end
  end

  scenario 'user views project on which they are a collaborator' do
    membership = FactoryGirl.create(:membership, role: 'collaborator')
    collaborator = membership.user
    project = membership.project
    sign_in_as(collaborator)

    click_link 'Projects'
    within '.collaborated' do
      expect(page).to have_content(project.title)
    end
  end

  scenario 'user does not see project on which they have no association' do
    random_project = FactoryGirl.create(:project)
    user = FactoryGirl.create(:user)
    sign_in_as(user)

    click_link 'Projects'
    expect(page).to_not have_content(random_project.title)

    visit project_path(random_project)
    expect(page).to have_content('You are not authorized to view this project.')
    expect(page).to have_link('New Project')
  end
end
