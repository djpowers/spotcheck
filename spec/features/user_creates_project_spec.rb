require 'spec_helper'

feature 'user creates project', %Q{
  As an authenticated user
  I want to create a project
  So that my related videos can be kept and viewed together
} do

  # Acceptance Criteria
  # user must be signed in to add project
  # project name must be specified
  # project name cannot be duplicated
  # creating a project shows an empty project window
  # empty project name triggers error message

  let(:user) { FactoryGirl.create(:user) }

  scenario 'user is not authenticated' do
    visit new_project_path

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  scenario 'required information is supplied' do
    sign_in_as(user)
    click_link 'New Project'

    project = FactoryGirl.build(:project)

    fill_in 'Title', with: project.title
    fill_in 'Description', with: project.description
    fill_in 'Status', with: project.status

    within '#project_due_date_1i' do
      select '2014'
    end
    within '#project_due_date_2i' do
      select 'February'
    end
    within '#project_due_date_3i' do
      select '28'
    end
    within '#project_due_date_4i' do
      select '17'
    end
    within '#project_due_date_5i' do
      select '00'
    end

    click_button 'Create Project'

    expect(page).to have_content('Project was successfully created.')
    expect(page).to have_content(project.title)
    expect(page).to have_content(project.description)
    expect(page).to have_content(project.status)
    expect(page).to have_content("2014-02-28 17:00")
  end

  scenario 'required information is not supplied' do
    sign_in_as(user)
    visit new_project_path
    click_button 'Create Project'

    within '.input.project_title' do
      expect(page).to have_content("can't be blank")
    end
  end

  scenario 'user creates project and is listed as creator' do
    sign_in_as(user)
    visit new_project_path
    click_button 'Create Project'

    creator_project = FactoryGirl.build(:project)
    random_project = FactoryGirl.create(:project, title: 'Not Your Project')
    fill_in 'Title', with: creator_project.title
    fill_in 'Description', with: creator_project.description
    fill_in 'Status', with: creator_project.status
    click_button 'Create Project'

    visit projects_path
    expect(page).to have_content(creator_project.title)
    expect(page).to_not have_content(random_project.title)
  end

end
