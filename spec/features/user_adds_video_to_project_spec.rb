require 'spec_helper'

feature 'user adds video to project', %Q{
  As a registered user
  I want to upload a video to a project
  So that other users can view them
  } do

    # Acceptance Criteria
    #
    # user specifies a video to upload
    # user must specify a title and revision number
    # user optionally specifies a description
    # video is uploaded and appears in project
    # if upload problem, error message is presented

    scenario 'creator adds video to project' do
      prev_count = Video.count
      membership = FactoryGirl.create(:membership, role: 'creator')
      video = FactoryGirl.build(:video)
      creator = membership.user
      project = membership.project
      sign_in_as(creator)

      click_link 'Projects'
      within "#project_#{project.id}" do
        click_link 'Show'
      end
      click_link 'Upload Video'

      attach_file 'Video Upload', Rails.root.join('spec/file_fixtures/valid_video.mp4')
      fill_in 'Revision Number', with: video.revision_number
      click_button 'Create Video'

      expect(page).to have_content(video.revision_number)
      expect(page).to have_content('Video was uploaded successfully')
      expect(Video.count).to eql(prev_count + 1)
      expect(Video.last.video_file.url).to be_present
    end

    scenario 'creator specifies invalid video format' do
      membership = FactoryGirl.create(:membership, role: 'creator')
      creator = membership.user
      project = membership.project
      sign_in_as(creator)

      click_link 'Projects'
      within "#project_#{project.id}" do
        click_link 'Show'
      end

      click_link 'Upload Video'

      attach_file 'Video Upload', Rails.root.join('spec/file_fixtures/invalid_file.rtf')
      fill_in 'Revision Number', with: 1
      click_button 'Create Video'

      expect(page).to have_content('Please specify a valid file to upload.')
    end

    scenario 'created adds video, submits blank form' do
      membership = FactoryGirl.create(:membership, role: 'creator')
      creator = membership.user
      project = membership.project
      sign_in_as(creator)

      click_link 'Projects'
      within "#project_#{project.id}" do
        click_link 'Show'
      end

      click_link 'Upload Video'
      click_button 'Create Video'

      expect(page).to have_content('Please specify a valid file to upload.')
      within '.video_revision_number' do
        expect(page).to have_content('is not a number')
      end
    end

    scenario 'collaborator adds video to project, denied' do
      membership = FactoryGirl.create(:membership, role: 'collaborator')
      collaborator = membership.user
      project = membership.project
      sign_in_as(collaborator)

      click_link 'Projects'
      within "#project_#{project.id}" do
        click_link 'Show'
      end
      click_link 'Upload Video'
      expect(page).to have_content('You are not authorized to manage members or videos in this project.')
    end
  end
