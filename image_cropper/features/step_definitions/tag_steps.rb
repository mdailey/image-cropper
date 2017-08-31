
Given(/^there is 1 unassigned tag$/) do
  @tag = FactoryGirl.create :tag, name: 'abc'
end

Then(/^I should see a tag form$/) do
  expect(page).to have_selector('form input#tag_name')
end

When(/^I submit the tag information$/) do
  @tag ||= Tag.new name: 'abc'
  fill_in 'Name', with: @tag.name
  click_button 'Submit'
end

Given(/^I want to add a tag with Thai characters$/) do
  @tag = Tag.new name: 'ก'
end

Then(/^I should see the tag information$/) do
  @tag ||= Tag.first
  expect(page).to have_css 'div#tag_name', text: @tag.name
end

Then(/^I should see the tag in the list$/) do
  @tag ||= Tag.first
  rows = find("table").all('tr')
  rows.map { |r| r.all('td.tag_name').map { |c|
    expect(c.text.strip).to eq(@tag.name)
  } }
end

When(/^I click the edit link in the tag list$/) do
  find(:xpath, "//*[@id='edit_tag_#{@tag.id}']").click
end

When(/^I click the delete link in the tag list$/) do
  find(:xpath, "//*[@id='delete_tag_#{@tag.id}']").click
  page.evaluate_script('window.confirm = function() { return true; }')
end

