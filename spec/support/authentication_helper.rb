module AuthenticationHelper
  def sign_in_as(user)
    visit root_path
    click_link 'Sign In'
    within '.sign_in' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign In'
    end
  end
end
