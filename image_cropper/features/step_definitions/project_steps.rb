Given(/^there is 1 project$/) do
  @project = FactoryGirl.create :project, user_id: @user.id, isactive: true
end

Given(/^there is 1 project image$/) do
  @project_image = FactoryGirl.create :project_image, project_id: @project.id
end

Then(/^I should see a project form$/) do
  expect(page).to have_selector('form input#project_name')
  expect(page).to have_selector('form textarea#project_description')
  expect(page).to have_selector('form input#project_images')
  expect(page).to have_selector('form select#project_crop_points')
  expect(page).to have_selector('form input#project_isactive')
end

When(/^I submit the project information$/) do
  fill_in 'Name', with: 'Giant' if @project.nil?
  fill_in 'Description', with: 'I am now testing.'
  select('4 Points', :from => 'project[crop_points]')
  attach_file("project_images", "#{Rails.root.to_s}/public/doraemon1.jpg")
  click_button 'Submit'
end

Then(/^I should see the project information$/) do
  @project = Project.first
  expect(page).to have_css 'div#project_name', text: @project.name
  expect(page).to have_css 'div#project_description', text: @project.description
  expect(page).to have_css 'div#project_crop_points', text: @project.crop_points
  expect(page).to have_css 'div#project_isactive', text: @project.isactive
  expect(page).to have_css 'div#project_user', text: @project.user.name
end

Then(/^I should see the project in the list$/) do
  rows = find("table").all('tr')
  rows.map { |r| r.all('td.project_name').map { |c|
    expect(c.text.strip).to eq(@project.name)
  } }
end

When(/^I click the edit link in the project list$/) do
  find(:xpath, "//*[@id='edit_project_#{@project.id}']").click
end

When(/^I click the assign link in the project list$/) do
  find(:xpath, "//*[@id='assign_project_#{@project.id}']").click
end

When(/^I click the delete link in the project list$/) do
  find(:xpath, "//*[@id='delete_project_#{@project.id}']").click
  page.evaluate_script('window.confirm = function() { return true; }')
end

Then(/^The project should be deleted$/) do
  expect(Project.all.size).to eq(0)
end
