Given(/^there is 1 project$/) do
  @project = Project.find_by_name 'Doraemon'
  @project ||= FactoryGirl.create :project, user_id: @user.id, isactive: true
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
  fill_in 'Name', with: 'Doraemon' if @project.nil?
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
  expect(page).to have_css('tr', text: /#{@project.name}/)
  find(:xpath, "//*[@id='delete_project_#{@project.id}']").click
  page.evaluate_script('window.confirm = function() { return true; }')
end

Then(/^the project should be deleted from the project list$/) do
  expect(page).not_to have_css('tr', text: /#{@project.name}/)
end

When(/^I click the download link in the project list$/) do
  page.find('tr', text: /#{@project.name}/).find('a', text: /Download/).click
end

Then(/^I should see a zip file$/) do
  expect(page.response_headers['Content-Type']).to eq("application/octet-stream")
end

Then(/^I should see a tag list for the project$/) do
  expect(page).to have_css('div', text: /Tags/)
end

Then(/^the tag list for the project should (not )?be empty$/) do |neg|
  css = 'li.token-input-token'
  if neg.blank?
    expect(page).not_to have_css(css)
  else
    expect(page).to have_css(css)
  end
end

When(/^I add the tag to the project$/) do
  fill_token_input 'project_tag_tokens', with: @tag.name
  click_button('Submit')
end

Then(/^I should see the tag in the tag list for the project$/) do
  expect(page).to have_css('div#project_tags', text: /#{@tag.name}/)
end

Then(/^I should see the tag(s)? in the tag tokeninput list for the project$/) do |plural|
  @project.tags.each do |tag|
    expect(page).to have_css('li.token-input-token', text: /#{tag.name}/)
  end
end

Given(/^the project has (\d+) tag(s)?$/) do |num, plural|
  [0..num.to_i-1].each do |i|
    tag = FactoryGirl.create :tag
    @project.tags << tag
  end
  @project.save
end

When(/^I delete the tag from the project$/) do
  delete_token_input 'project_tag_tokens', with: @project.tags.first.name
end
