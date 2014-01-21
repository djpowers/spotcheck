require 'spec_helper'

feature 'user deletes project', %Q{
  As a user
  I want to delete a project
  So that it is no longer accessible
} do

  # Acceptable Criteria
  #
  # project can be removed
  # user must confirm deletion
  # removal of page returns to user page
  # linking to page informs user project was removed
  # deleting project removes associated videos and comments

  scenario 'creator deletes project' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    creator = membership.user
    project = membership.project
    video = FactoryGirl.create(:video, project: project)
    FactoryGirl.create(:comment, video: video)
    expect(Project.count).to eql(1)
    expect(Video.count).to eql(1)
    expect(video.comments.count).to eql(1)
    sign_in_as(creator)

    visit projects_path
    within "#project_#{project.id}" do
      click_link 'Delete Project'
    end
    expect(page).to have_content('Project has been successfully deleted.')
    expect(page).to_not have_content(project.title)
    expect(Project.count).to eql(0)
    expect(Video.count).to eql(0)
    expect(video.comments.count).to eql(0)
  end

  scenario 'collaborator removes membership' do
    membership = FactoryGirl.create(:membership, role: 'collaborator')
    collaborator = membership.user
    project = membership.project
    sign_in_as(collaborator)

    visit projects_path
    within "#project_#{project.id}" do
      click_link 'Remove Membership'
    end
    expect(page).to have_content('You have been removed from the project.')
  end

end
