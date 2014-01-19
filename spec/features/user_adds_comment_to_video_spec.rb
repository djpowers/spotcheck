require 'spec_helper'

feature 'user adds comment to video', %Q{
  As a user
  I want to comment on specific videos
  So that I may provide changes or grant approval
} do

  # Acceptance Criteria
  # user must be authenticated to comment on video
  # comment auto-fills user's name and video revision number
  # comment must provide text and status ("changes needed" or "approved")
  # comment includes timestamp
  # a specific timecode can be specified

  scenario 'creator comments on video' do
    user = FactoryGirl.create(:user)
    video = FactoryGirl.create(:video)
    project = video.project
    FactoryGirl.create(:membership, user: user, project: project)
    comment = FactoryGirl.build(:comment)
    sign_in_as(user)

    click_link 'Projects'

    within "#project_#{project.id}" do
      click_link 'Show'
    end

    within "#video_#{video.id}" do
      click_link 'Show'
    end

    fill_in 'Body', with: comment.body
    fill_in 'Timecode Start', with: comment.timecode_start
    fill_in 'Timecode End', with: comment.timecode_end
    click_button 'Create Comment'

    expect(page).to have_content('Comment was successfully added.')
    expect(page).to have_content(comment.body)
  end

  scenario 'collaborator comments on video' do
    user = FactoryGirl.create(:user)
    video = FactoryGirl.create(:video)
    project = video.project
    FactoryGirl.create(:membership, user: user, project: project, role: 'collaborator')
    comment = FactoryGirl.build(:comment)
    sign_in_as(user)

    click_link 'Projects'

    within "#project_#{project.id}" do
      click_link 'Show'
    end

    within "#video_#{video.id}" do
      click_link 'Show'
    end

    fill_in 'Body', with: comment.body
    fill_in 'Timecode Start', with: comment.timecode_start
    fill_in 'Timecode End', with: comment.timecode_end
    click_button 'Create Comment'

    expect(page).to have_content('Comment was successfully added.')
    expect(page).to have_content(comment.body)
  end

  scenario 'collaborator submits blank comment' do
    user = FactoryGirl.create(:user)
    video = FactoryGirl.create(:video)
    project = video.project
    FactoryGirl.create(:membership, user: user, project: project, role: 'collaborator')
    comment = FactoryGirl.build(:comment)
    sign_in_as(user)
    visit project_video_path(project, video)

    click_button 'Create Comment'
    expect(page).to have_content("Comment body can't be blank.")
  end

end
