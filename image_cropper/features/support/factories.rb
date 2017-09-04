include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :role_admin, class: :role do
    id 1
    name 'Administrator'
  end

  factory :role_uploader, class: :role do
    id 2
    name 'Uploader'
  end

  factory :role_cropper, class: :role do
    id 3
    name 'Cropper'
  end

  factory :admin, class: :user do
    name 'Admin'
    email 'admin@hotmail.com'
    password 'secret'
    is_active true
    role_id 1
  end

  factory :uploader, class: :user do
    name 'Uploader'
    email 'uploader@hotmail.com'
    password 'secret'
    is_active true
    role_id 2
  end

  factory :cropper, class: :user do
    sequence(:name) { |i| "Cropper #{i}" }
    sequence(:email) { |i| "cropper#{i}@hotmail.com" }
    password 'secret'
    is_active true
    role_id 3
  end

  factory :project do
    name 'Doraemon'
    description ''
    crop_points 4
  end

  factory :project_image do
    sequence(:image) { |i| "doraemon#{i}.jpg" }
    w 500
    h 500
  end

  factory :project_user do
  end

  factory :project_crop_image do
    #crop_number: 1
  end

  factory :project_crop_image_cord do
    #crop_number: 1
  end

  factory :tag do
   sequence(:name) { |i| "Tag#{i}" }
  end

end
