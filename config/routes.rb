Rails.application.routes.draw do
  $user_prefix = "users"

  scope "/api" do
    scope '/v1' do
      # Users routes
      post "#$user_prefix/sign_up", to: 'users#sign_up'
      patch "#$user_prefix/verify_email", to: 'users#verify_email'
      post "#$user_prefix/sign_in", to: 'users#sign_in'
      put "#$user_prefix/change_password", to: 'users#change_password'
      get "#$user_prefix/:id", to: 'users#find_by_id'
      delete "#$user_prefix/:id", to: 'users#destroy'
      # 
    end
  end
  # Defines the root path route ("/")
  root "main#index"
end
