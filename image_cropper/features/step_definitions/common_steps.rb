
def submit_login_form
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Log in'
end

def set_default_role
  FactoryGirl.create :role_admin
  FactoryGirl.create :role_uploader
  FactoryGirl.create :role_cropper
end

Given(/^I am an admin$/) do
  set_default_role
  @user = FactoryGirl.create :admin
end

Given(/^I am an uploader$/) do
  set_default_role
  @user = FactoryGirl.create :uploader
end

Given(/^I am a cropper$/) do
  set_default_role
  @user = FactoryGirl.create :cropper
end

Given(/^I am signed in$/) do
  visit '/users/sign_in'
  submit_login_form
end

When(/^I visit (.*)$/) do |page|
  case page
    when 'the main page'
      visit root_path
    when 'the project page'
      visit uploader_projects_path
    when 'the user page'
      visit admin_users_path
    when 'the assigned project page'
      create_mock_project_image_folder()
      visit cropper_projects_path
    else
      raise 'Unexpected page description'
  end
end

Then(/^I should see a login form$/) do
  expect(page).to have_selector('form input#user_email')
  expect(page).to have_selector('form input#user_password')
end

When(/^I submit the login form$/) do
  submit_login_form
end

Then(/^I should see a "(.*)" link$/) do |link_text|
  case link_text
    when 'current user'
      expect(page).to have_link @user.name
    else
      expect(page).to have_link link_text
  end
end

When(/^I click the "(.*)" link$/) do |link_text|
  case link_text
    when 'current user'
      click_link @user.name
    else
      click_link link_text
  end
end
