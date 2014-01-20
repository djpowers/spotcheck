require 'spec_helper'

feature 'user deletes video', %Q{
  As a user
  I want to delete a video
  So that it is no longer accessible
} do

  # Acceptable Criteria
  #
  # video can be removed
  # user must confirm deletion
  # removal of page returns to project page
  # linking to page informs user video was removed
  # deleting video removes associated comments

  scenario 'creator deletes video' do
    membership = FactoryGirl.create(:membership, role: 'creator')
    creator = membership.user
    project = membership.project
    video = FactoryGirl.create(:video, project: project)
    FactoryGirl.create(:comment, video: video)
    expect(Video.count).to eql(1)
    expect(video.comments.count).to eql(1)
    sign_in_as(creator)

    visit project_path(project)
    within "#video_#{video.id}" do
      click_link 'Destroy'
    end
    expect(page).to have_content('Video has been removed from the project.')
    expect(Video.count).to eql(0)
    expect(video.comments.count).to eql(0)
  end

  scenario 'collaborator deletes video, is denied' do
    membership = FactoryGirl.create(:membership, role: 'collaborator')
    collaborator = membership.user
    project = membership.project
    video = FactoryGirl.create(:video, project: project)
    sign_in_as(collaborator)

    visit project_path(project)
    within "#video_#{video.id}" do
      click_link 'Destroy'
    end
    expect(page).to have_content('You are not authorized to manage videos for this project.')
  end

end
