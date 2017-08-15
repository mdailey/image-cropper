Rails.application.routes.draw do

  namespace :cropper do
    resources :projects do
      resources :project_images do
        resources :project_crop_images
      end
    end
  end

  namespace :admin do
    resources :users do
      resources :project_users
    end
  end

  namespace :uploader do
   resources :tags
   resources :projects do
     resources :project_users
     resources :project_images
     resources :project_crop_images
   end
  end

  devise_for :users

  devise_scope :user do
    post "users/password" => "devise/passwords#create", as: "password"
    get "users/password/new" => "devise/passwords#new", as: "new_password"
    get "users/password/edit" => "devise/passwords#edit", as: "edit_password"
  end

  get 'site/index'

  root 'site#index'

end
