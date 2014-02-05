require 'spec_helper'

feature 'user submits inquiry', %Q{
  As a site visitor
  I want to contact the site's staff
  So that I can ask questions or make comments about the site
} do

  # Acceptance Criteria:
  #
  # I must specify a valid email address
  # I must specify a subject
  # I must specify a description
  # I must specify a first name
  # I must specify a last name

  # The dispatched email should come from the visitor's email address
  # The dispatched email should include the visitor's first and last name
  # The dispatched email should content description information submitted


  scenario 'user submits form with valid fields' do
    ActionMailer::Base.deliveries = []

    visit root_path

    click_link 'Contact Us'
    within '.contact' do
      fill_in 'First Name', with: 'John'
      fill_in 'Last Name', with: 'Doe'
      fill_in 'Email', with: 'johndoe@mail.com'
      fill_in 'Subject', with: 'Hello'
      fill_in 'Body', with: 'Just wanted to say hi.'
      click_button 'Submit Inquiry'
    end
    expect(page).to have_content('Inquiry was successfully submitted.')

    expect(ActionMailer::Base.deliveries.size).to eql(1)
    last_email = ActionMailer::Base.deliveries.last
    expect last_email.to have_subject('Hello')
    expect last_email.to deliver_to('djpowers89@gmail.com')
    expect last_email.to have_body_text('Inquiry was successfully submitted.')
  end

end
