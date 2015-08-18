def create_mock_project_image_folder
  file_path = "#{Rails.root.to_s}/public/system/#{@project.name}"
  system("mkdir -p #{file_path}")
  file_name = "#{Rails.root.to_s}/public/doraemon1.jpg"
  system("cp #{file_name} #{file_path}/doraemon1.jpg")
end

def delete_mock_project_image_folder
  file_path = "#{Rails.root.to_s}/public/system/#{@project.name}"
  system("rm -r #{file_path}")
end

Then(/^I should see the assigned project in the list$/) do
  rows = find("table").all('tr')
  rows.map { |r| r.all('td.project_name').map { |c|
    expect(c.text.strip).to eq("Project-#{@project_user.project.id}: #{@project_user.project.name}")
  } }
end

When(/^I click the show link in the assigned project list$/) do
  find(:xpath, "//*[@id='show_project_#{@project.id}']").click
end

When(/^I click the assign link in the assigned project list$/) do
  find(:xpath, "//*[@id='assign_project_#{@project.id}']").click
end

Then(/^I should see an image of assigned project$/) do
  expect(page).to have_css 'canvas#canvas-1'
  image_path = page.evaluate_script("$('canvas#canvas-1').attr('data-project-image')")
  expect(image_path.to_s).to eq "/system/#{@project.name}/#{@project_image.image}"
end

When(/^I click on an image for cropping$/) do
  page.evaluate_script "paper.tool.emit('mouseup', { point: { x: #{70}, y: #{433}}})"
  page.evaluate_script "paper.tool.emit('mouseup', { point: { x: #{71}, y: #{252}}})"
  page.evaluate_script "paper.tool.emit('mouseup', { point: { x: #{182}, y: #{259}}})"
  page.evaluate_script "paper.tool.emit('mouseup', { point: { x: #{190}, y: #{431}}})"
  page.evaluate_script "$('body').trigger($.Event( 'keyup', { which: 13 } ))"
end

Then(/^I should see cropped points on an image$/) do
  sleep(0.4)
  expect(ProjectCropImage.all.size).to eq(4)
end
