Given(/^there is 1 user$/) do
  @new_user = FactoryGirl.create :cropper
end

Given(/^there is 1 tag$/) do
  @tag = FactoryGirl.create :tag
end

Given(/^there is 1 user assigned to project$/) do
  @project_user = FactoryGirl.create :project_user, project_id: @project.id, user_id: (@new_user)? @new_user.id : @user.id, tag_id: @tag.id
end

Then(/^I should see a user form$/) do
  expect(page).to have_selector('form input#user_name')
  expect(page).to have_selector('form input#user_email')
  expect(page).to have_selector('form select#user_role_id')
  expect(page).to have_selector('form input#user_is_active')
end

When(/^I submit the user information$/) do
  fill_in 'Name', with: 'Cropper'
  fill_in 'Email', with: 'cropper@hotmail.com'
  select('Cropper', :from => 'Role')
  click_button 'Submit'
end

Then(/^I should see the user in the list$/) do
  @new_user = @new_user.nil?? User.last : @new_user
  rows = find("table").all('tr')
  rows.map { |r| r.all('td.user_name').map { |c|
    expect(c.text.strip).to eq(@new_user.name)
  } }
end

When(/^I click the edit link in the user list$/) do
  find(:xpath, "//*[@id='edit_user_#{@new_user.id}']").click
end

When(/^I click the activate link in the user list$/) do
  find(:xpath, "//*[@id='activate_user_#{@new_user.id}']").click
  page.evaluate_script('window.confirm = function() { return true; }')
end

And(/^I "(.*)" a user$/) do |text|
  case text
    when 'activate'
      @new_user.update(is_active: true)
    when 'deactivate'
      @new_user.update(is_active: false)
    else
      raise 'Unexpected status description'
  end
end

And(/^I should see a user "(.*)"$/) do |text|
  @new_user = User.last
  case text
    when 'activated'
      expect(@new_user.is_active).to eq(true)
    when 'deactivated'
      expect(@new_user.is_active).to eq(false)
    else
      raise 'Unexpected status description'
  end
end

When(/^I click the assign link in the user list$/) do
  find(:xpath, "//*[@id='assign_user_#{@new_user.id}']").click
end

Then(/^I should see the user information$/) do
  expect(page).to have_selector('div#divName')
  expect(page).to have_selector('div#divEmail')
end

And(/^I should see the project list$/) do
  expect(page).to have_selector('#tblProject')
end

When(/^I click checkbox to (.*) project$/) do |text|
  if (text == "assign")
    check("user-#{@new_user.id}")
  elsif (text == "unassign")
    uncheck("user-#{@new_user.id}")
  end
end

Then(/^the project should be (.*)$/) do |text|
  sleep(0.2)
  if (text == "assigned")
    expect(ProjectUser.first.user_id).to eq(@new_user.id)
    expect(ProjectUser.first.project_id).to eq(@project.id)
  elsif (text == "unassigned")
    expect(ProjectUser.all.size).to eq(0)
  end
end
