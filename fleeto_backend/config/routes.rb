Rails.application.routes.draw do

  devise_for :customers

  api_version(:module => "V1", :path => {:value => "v1"}) do
    namespace :customer do
      
      mount_devise_token_auth_for 'Customer', at: 'auth', controllers: {
        sessions: "v1/customer/sessions",
        registrations: "v1/customer/registrations"
      }

      resources :customers, only: [] do
        collection do
          post :verify
        end
      end

      resources :drivers, only: [] do
        collection do
          get :locate_near_drivers
        end
      end

    end

    namespace :driver do
      mount_devise_token_auth_for 'Driver', at: 'auth', controllers: {
        sessions: "v1/driver/sessions",
      }
    end

  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
