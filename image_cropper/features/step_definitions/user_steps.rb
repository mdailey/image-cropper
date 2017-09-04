
Given(/^there is 1 cropper$/) do
  @cropper = FactoryGirl.create :cropper
  @croppers = [ @cropper ]
end

Given(/^there (is|are) (\d+) user(s)? assigned to the project$/) do |verb, num, plural|
  num = num.to_i
  @croppers ||= []
  (num - @croppers.length).times do
    @croppers.push FactoryGirl.create(:cropper)
  end
  (0..num-1).each do |i|
    @project_user = FactoryGirl.create :project_user, project_id: @project.id, user_id: @croppers[i].id
  end
end

Given(/^I am cropper (\d+)$/) do |num|
  num = num.to_i
  @user = @croppers[num-1]
  @cropper = @user
end

Given(/^I am assigned to the project$/) do
  @project_user = FactoryGirl.create :project_user, project_id: @project.id, user_id: @cropper.id
end

Then(/^I should see a user form$/) do
  expect(page).to have_selector('form input#user_name')
  expect(page).to have_selector('form input#user_email')
  expect(page).to have_selector('form select#user_role_id')
  expect(page).to have_selector('form input#user_is_active')
end

When(/^I submit the user information$/) do
  fill_in 'Name', with: 'New cropper name'
  fill_in 'Email', with: 'newcropper@hotmail.com'
  select('Cropper', :from => 'Role')
  click_button 'Submit'
  @cropper.name = 'New cropper name' if @cropper
end

When(/^I click the edit link in the user list$/) do
  find(:xpath, "//*[@id='edit_user_#{@cropper.id}']").click
end

When(/^I click the activate link in the user list$/) do
  find(:xpath, "//*[@id='activate_user_#{@cropper.id}']").click
  page.evaluate_script('window.confirm = function() { return true; }')
end

And(/^I "(.*)" the user$/) do |text|
  case text
    when 'activate'
      @cropper.update(is_active: true)
    when 'deactivate'
      @cropper.update(is_active: false)
    else
      raise 'Unexpected status description'
  end
end

And(/^I should see a user "(.*)"$/) do |text|
  @cropper = User.last
  case text
    when 'activated'
      expect(@cropper.is_active).to eq(true)
    when 'deactivated'
      expect(@cropper.is_active).to eq(false)
    else
      raise 'Unexpected status description'
  end
end

When(/^I click the assign link in the user list$/) do
  click_link "assign_user_#{@cropper.id}"
  #find(:xpath, "//*[@id='assign_user_#{@cropper.id}']").click
end

Then(/^I should see the user information$/) do
  expect(page).to have_selector('div#divName')
  expect(page).to have_selector('div#divEmail')
end

And(/^I should see the project list$/) do
  expect(page).to have_selector('#tblProject')
end

When(/^I click the checkbox to (.*) the user (to|from) the project$/) do |text, tofrom|
  expect(page).to have_css("input#user-#{@cropper.id}")
  if (text == "assign")
    expect(page).not_to have_css("input#user-#{@cropper.id}[checked=\"checked\"]")
    check("user-#{@cropper.id}")
    wait_for_ajax
  elsif (text == "unassign")
    expect(page).to have_css("input#user-#{@cropper.id}[checked=\"checked\"]")
    uncheck("user-#{@cropper.id}")
    wait_for_ajax
  end
end

Then(/^the project should be (assigned|unassigned)$/) do |text|
  row = find('tr', text: /#{@cropper.name}/)
  if (text == "assigned")
    expect(row).to have_css('input[type="checkbox"][checked="checked"]')
  elsif (text == "unassigned")
    expect(row).not_to have_css('input[type="checkbox"][checked="checked"]')
  end
end
