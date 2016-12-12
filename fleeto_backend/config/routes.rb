Rails.application.routes.draw do

  # devise_for :customers

  api_version(:module => "V1", :path => {:value => "v1"}) do
    namespace :customer do
      mount_devise_token_auth_for 'Customer', at: 'auth', controllers: {
        registrations: "v1/customer/registrations"
      }
    end

  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
