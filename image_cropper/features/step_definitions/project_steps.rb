
Given(/^there is 1 project$/) do
  set_default_role
  @project = Project.find_by_name 'Doraemon'
  owner = @user || FactoryGirl.create(:uploader)
  @project ||= FactoryGirl.create :project, user_id: owner.id, isactive: true
  @project.isactive = true
  @project.save
end

Given(/^there (is|are) (\d+) project image(s)?$/) do |verb, num, plural|
  num = num.to_i
  @project_images = []
  num.times do
    @project_image = FactoryGirl.create :project_image, project_id: @project.id
    @project_images.push @project_image
  end
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
  expect(page).to have_css('table tr td', text: /#{@project_name}/)
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
  expect(page.response_headers['Content-Type']).to eq("application/zip")
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
  (0..num.to_i-1).each do |i|
    tag = FactoryGirl.create :tag
    @project.tags << tag
  end
  @project.save
end

When(/^I delete the tag from the project$/) do
  delete_token_input 'project_tag_tokens', with: @project.tags.first.name
end

def create_project_crop_images(num)
  @project_crop_images = []
  x = 0
  y = 50
  (0..num-1).each do |i|
    pci = ProjectCropImage.new project_image_id: @project_image.id, user_id: @cropper.id, image: "#{i}.jpg", tag_id: @project.tags.first.id
    coords = [{x: x, y: y}, {x: x+300, y: y}, {x: x+300, y: y+300}, {x: x, y: y+300}]
    coords.each do |coord|
      pci.project_crop_image_cords.push(ProjectCropImageCord.new x: coord[:x], y: coord[:y])
    end
    pci.save!
    @project_crop_images.push pci
    x = x + 100
  end
end

Given(/^there (is|are) (\d+) crop(s)? for (the )?project image( )?(\d+)?$/) do |verb, num, plural, the, space, index|
  num = num.to_i
  if !index.blank?
    @project_image = @project_images[index.to_i-1]
  end
  @cropper ||= FactoryGirl.create :cropper
  if @project.users.size == 0
    @project.users << @cropper
  end
  create_project_crop_images(num)
end

Given(/^cropper (\d+) has selected (\d+) objects$/) do |cropperi, num|
  save_cropper = @cropper
  @cropper = @croppers[cropperi.to_i-1]
  create_project_crop_images(num.to_i)
  @cropper = save_cropper
end

Then(/^I should see (\d+) crops$/) do |num|
  num = num.to_i
  sleep 1
  wait_for_ajax
  nl = page.evaluate_script("window.paper.project.layers.length")
  num_crops = 0
  (0..nl-1).each do |li|
    nc = page.evaluate_script("window.paper.project.layers[#{li}].children.length")
    (0..nc-1).each do |ci|
      # Tag objects have a _content attribute containing the tag string; paths and other objects don't
      content = page.evaluate_script("window.paper.project.layers[#{li}].children[#{ci}]._content")
      num_crops += 1 unless content.nil?
    end
  end
  expect(num_crops).to eql(num*2)
end

Given(/^the project image files are synced$/) do
  projects_path = Rails.application.config.projects_dir
  test_image_path = File.join(Rails.root, 'public', 'doraemon1.jpg')
  system("mkdir -p #{projects_path}")
  Dir.chdir projects_path
  system("rm -rf #{@project.name}")
  system("mkdir #{@project.name}")
  Dir.chdir @project.name
  @project.users.each do |pu|
    system("mkdir #{pu.id}")
  end
  @project.project_images.each do |pi|
    system("cp #{test_image_path} #{pi.image}")
    pi.project_crop_images.each do |pci|
      uid = pci.user.id
      file_path = File.join(projects_path, @project.name, uid.to_s, pci.image)
      system("cp #{test_image_path} #{file_path}")
    end
  end
  Dir.chdir Rails.root
end

Given(/^the project has rectangle thickness (\d+)$/) do |num|
  num = num.to_i
  @project.rectangle_thickness = num
  @project.save
end

Then(/^I should see the download link in the project list$/) do
  expect(page).to have_css('tr', text: /#{@project.name}/)
  anchor = find('tr', text: /#{@project.name}/).find('a', text: /Download/)
  @download_link = anchor['href']
end

When(/^I open the downloaded ZIP file$/) do
  system("rm -rf #{Rails.root}/tmp/downloads/*")
  within('tr', text: /#{@project.name}/) do
    click_link('Download images')
  end
  Timeout.timeout(10) do
    while Dir.glob("#{Rails.root}/tmp/downloads/*").size == 0
      sleep 1
    end
  end
  files = Dir.glob("#{Rails.root}/tmp/downloads/*")
  expect(files.size).to eql(1)
  found = false
  yaml_found = false
  expected = "#{@project.name}/CNN/#{@project_image.image.gsub(/\.jpg$/,'')}.txt"
  expected_yaml = "#{@project.name}/#{@project.name}.yml"
  @project_images_in_zip = 0
  @project_crop_images_in_zip = 0
  Zip::File.open(files[0]) do |zipfile|
    zipfile.each do |thisfile|
      if thisfile.to_s == expected
        found = true
        @cnn_file_content = thisfile.get_input_stream.read
      end
      if thisfile.to_s == expected_yaml
        yaml_found = true
        @yaml_file_content = thisfile.get_input_stream.read
      end
      if thisfile.to_s =~ /\/original\//
        @project_images_in_zip += 1
      end
      if thisfile.to_s =~ /\/crops\//
        @project_crop_images_in_zip += 1
      end
    end
  end
  expect(found).to be(true)
  expect(yaml_found).to be(true)
end

Then(/^I should see a CNN text file for the project image$/) do
  expect(@cnn_file_content).not_to be(nil)
  expect(@cnn_file_content.lines.count).to eql(@project_image.project_crop_images.size)
end

Then(/^I should see a YML file for the project$/) do
  expect(@yaml_file_content).not_to be(nil)
end

Then(/^I should see (\d+) project image in the ZIP file$/) do |num|
  expect(@project_images_in_zip).to eql(num.to_i)
end

Then(/^I should see (\d+) crop images in the ZIP file$/) do |num|
  expect(@project_crop_images_in_zip).to eql(num.to_i)
end

When(/^I change the rectangle thickness for the project$/) do
  @thickness = 3
  fill_in('Rectangle thickness', with: @thickness)
  click_button('Submit')
end

Then(/^the rectangle thickness should be changed$/) do
  expect(page).to have_css('div#thickness', text: @thickness.to_s)
end
