Rails.application.routes.draw do

  # needed to generate methods
  devise_for :customers
  devise_for :drivers

  namespace :customer do
    api_version(:module => "V1", :path => {:value => "v1"}) do
      
      mount_devise_token_auth_for 'Customer', at: 'auth', controllers: {
        sessions: "customer/v1/sessions",
        registrations: "customer/v1/registrations"
      }

      resources :customers, only: [] do
        collection do
          post :verify
        end
      end

      resources :locations, only: [] do
        collection do
          post :set_location
          get :locate_near_drivers
        end
      end

      resources :trip_requests, only: [:create, :destroy]
    end

  end


  namespace :driver do
    api_version(:module => "V1", :path => {:value => "v1"}) do

      mount_devise_token_auth_for 'Driver', at: 'auth', controllers: {
        sessions: "driver/v1/sessions",
      }

      resources :locations, only: [] do
        collection do
          post :set_location
        end
      end

      resources :trip_requests, only: [] do
        member do
          post :accept
        end
      end

    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
