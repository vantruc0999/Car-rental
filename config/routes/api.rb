namespace :api do
    namespace :v1 do
        scope :users, module: :users do
            post '/', to: "auth#create", as: :user_registration
            get '/confirm/:confirmation_token', to: "auth#confirm", as: :user_confirmation
            post 'password/forgot', to: 'auth#forgot'
            post 'password/reset/:token', to: 'auth#reset'
        end

        resources :brands

        resources :car_models

        resources :cars do 
            collection do
                get '/recommend', to: "cars#recommend"
            end
        end

        resources :bookings do
            collection do
                post '/create-booking', to: "bookings#create"
                post '/:car_id/reviews', to: "bookings#create_review"
            end
        end
    end
end

scope :api do
    scope :v1 do
        use_doorkeeper do
            skip_controllers :authorizations, :applications, :authorized_applications
        end
    end
end