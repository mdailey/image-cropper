Given(/^there is 1 cropped image$/) do
  @project_crop_image = FactoryGirl.create :project_crop_image, project_image_id: @project_image.id, user_id: (@new_user)? @new_user.id : @user.id, image: "20150922205514.jpg"
  cords = ([{x: 0, y: 0}, {x: 300, y: 0}, {x: 300, y: 300}, {x: 0, y: 300}]).to_json
  @i = 0
  while(@i < cords.length)
    @project_crop_image_cords = FactoryGirl.create :project_crop_image_cord, project_crop_image_id: @project_crop_image.id, x: cords[@i]["x"].to_f, y: cords[@i]["y"].to_f
    @i += 1
  end
end

def create_mock_project_image_folder
  file_path = "#{Rails.root.to_s}/public/system/projects/#{@project.name}"
  system("mkdir -p #{file_path}")
  file_name = "#{Rails.root.to_s}/public/doraemon1.jpg"
  system("cp #{file_name} #{file_path}/doraemon1.jpg")
end

def delete_mock_project_image_folder
  file_path = "#{Rails.root.to_s}/public/system/projects/#{@project.name}"
  system("rm -r #{file_path}")
end

Then(/^I should see the assigned project in the list$/) do
  expect(page).to have_css('tr', text: /#{@project_user.project.name}/)
end

When(/^I click the crop images link in the assigned project list$/) do
  find(:xpath, "//*[@id='assign_project_#{@project.id}']").click
end

Then(/^I should see an image of assigned project$/) do
  expect(page).to have_css 'canvas#canvas-1'
  image_path = page.evaluate_script("$('canvas#canvas-1').attr('data-project-image')")
  expect(image_path.to_s).to eq "/system/projects/#{@project.name}/#{@project_image.image}"
end

When(/^I click on an image for cropping$/) do
  page.evaluate_script "paper.tool.emit('mousedown', { point: {x: #{70}, y: #{433}}, event: {buttons: 1} })"
  page.evaluate_script "paper.tool.emit('mousedown', { point: {x: #{71}, y: #{252}}, event: {buttons: 1}  })"
  page.evaluate_script "paper.tool.emit('mousedown', { point: {x: #{182}, y: #{259}}, event: {buttons: 1}  })"
  page.evaluate_script "paper.tool.emit('mousedown', { point: {x: #{190}, y: #{431}}, event: {buttons: 1}  })"
  page.evaluate_script "$('body').trigger($.Event( 'keyup', { which: 13 } ))"
end

Then(/^I should see cropped points on an image$/) do
  sleep(0.5)
  expect(ProjectCropImage.all.size).to eq(1)
  expect(ProjectCropImageCord.all.size).to eq(4)
end
