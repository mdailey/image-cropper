
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

Then(/^I should see an image from the assigned project$/) do
  expect(page).to have_css 'canvas#canvas-1'
  image_path = page.evaluate_script("$('canvas#canvas-1').attr('data-project-image')")
  expect(image_path.to_s).to eq "/system/projects/#{@project.name}/#{@project_image.image}"
end

When(/^I select an object on the image to be cropped$/) do
  page.evaluate_script "paper.tool.emit('mousedown', { point: {x: #{70}, y: #{433}}, event: {buttons: 1} })"
  wait_for_ajax
  page.evaluate_script "paper.tool.emit('mousedown', { point: {x: #{71}, y: #{252}}, event: {buttons: 1}  })"
  wait_for_ajax
  page.evaluate_script "paper.tool.emit('mousedown', { point: {x: #{182}, y: #{259}}, event: {buttons: 1}  })"
  wait_for_ajax
  page.evaluate_script "paper.tool.emit('mousedown', { point: {x: #{190}, y: #{431}}, event: {buttons: 1}  })"
  wait_for_ajax
  page.evaluate_script "$('body').trigger($.Event( 'keyup', { which: 13 } ))"
  wait_for_ajax
end

Then(/^I should see the object selected on the image$/) do
  expect(ProjectCropImage.all.size).to eq(1)
  expect(ProjectCropImageCord.all.size).to eq(4)
end

def wait_for_ajax
  Timeout.timeout(5) do
    loop until page.evaluate_script('jQuery.active').zero?
  end
end

When(/^I crop (\d+) patches then delete (\d+) patch$/) do |num_crop, num_delete|
  wait_for_ajax
  ProjectCropImage.all.each { |pci| pci.delete }
  Dir.glob(File.join(Rails.application.config.projects_dir, @project.name, @user.id.to_s, '*')).each do |f|
    system("rm -f #{f}")
  end
  expect(ProjectCropImageCord.all.size).to eql(0)
  num_crop = num_crop.to_i
  num_delete = num_delete.to_i
  x = 50
  y = 50
  w = 50
  h = 50
  num_crop.times do
    page.evaluate_script "paper.tool.emit('mousedown', { point: {x: #{x}, y: #{y}}, event: {buttons: 1} })"
    wait_for_ajax
    page.evaluate_script "paper.tool.emit('mousedown', { point: {x: #{x+w}, y: #{y}}, event: {buttons: 1}  })"
    wait_for_ajax
    page.evaluate_script "paper.tool.emit('mousedown', { point: {x: #{x+w}, y: #{y+h}}, event: {buttons: 1}  })"
    wait_for_ajax
    page.evaluate_script "paper.tool.emit('mousedown', { point: {x: #{x}, y: #{y+h}}, event: {buttons: 1}  })"
    wait_for_ajax
    page.evaluate_script "$('body').trigger($.Event( 'keyup', { which: 13 } ))"
    wait_for_ajax
    x = x + 2 * w
  end
  expect(ProjectCropImage.all.size).to eql(num_crop)
  expect(ProjectCropImageCord.all.size).to eql(num_crop * 4)
  x = 50
  num_delete.times do
    # Cheating here, as I haven't figured out how to activate the context menu from capybara or JS
    page.evaluate_script "$.post($('#canvas-1').attr('data-crop-url') + '/1?x=' + #{x} + '&y=' + #{y}, { _method: 'delete' }, null, 'script')"
    wait_for_ajax
    x = x + 2 * w
  end

end

Then(/^there should be (\d+) patch left$/) do |num_crop|
  num_crop = num_crop.to_i
  files = Dir.glob(File.join(Rails.application.config.projects_dir, @project.name, @user.id.to_s, '*'))
  expect(files.size).to eql(num_crop)
end
