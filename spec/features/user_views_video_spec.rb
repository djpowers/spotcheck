require 'spec_helper'

feature 'user views video', %Q{
  As an authenticated user
  I want to view a video
  So that I may see the latest version
} do

  # Acceptance Criteria

  # I must be a member of a project to view a video
  # if I am not a member, I receive an error message
  # video appears on page and is playable
  # comment box appears on page
  # comments appear on page
  # video information/metadata appears on page

  scenario 'creator views video' do
    user = FactoryGirl.create(:user)
    video = FactoryGirl.create(:video)
    project = video.project
    FactoryGirl.create(:membership, user: user, project: project)
    sign_in_as(user)

    click_link 'Projects'

    within "#project_#{project.id}" do
      click_link 'Show'
    end
    expect(page).to have_content(video.revision_number)

    within "#video_#{video.id}" do
      click_link 'Show'
    end
    expect(page).to have_content(video.revision_number)
    expect(page).to have_content(video.approved)
    expect(page).to have_content(video.created_at)
  end

  scenario 'collaborator views video' do
    user = FactoryGirl.create(:user)
    video = FactoryGirl.create(:video)
    project = video.project
    FactoryGirl.create(:membership, user: user, project: project, role: 'collaborator')
    sign_in_as(user)

    click_link 'Projects'

    within "#project_#{project.id}" do
      click_link 'Show'
    end
    expect(page).to have_content(video.revision_number)

    within "#video_#{video.id}" do
      click_link 'Show'
    end
    expect(page).to have_content(video.revision_number)
    expect(page).to have_content(video.approved)
    expect(page).to have_content(video.created_at)
  end

  scenario 'unassociated user views video, is denied' do
    user = FactoryGirl.create(:user)
    video = FactoryGirl.create(:video)
    project = video.project
    sign_in_as(user)

    visit project_video_path(project, video)
    expect(page).to have_content('You are not authorized to view this project.')
    expect(page).to have_link('New Project')
  end

end
