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

      fill_in 'Resource', with: video.resource
      fill_in 'Revision Number', with: video.revision_number
      click_button 'Create Video'

      expect(page).to have_content(video.revision_number)
    end

    scenario 'created adds video, submits blank form'

    scenario 'collaborator adds video to project, denied'

  end
