Rails.application.routes.draw do
  $user_prefix = "users"

  scope "/api" do
    scope '/v1' do
      # Users routes
      post "#$user_prefix/sign_up", to: 'users#sign_up'
      post "#$user_prefix/sign_in", to: 'users#sign_in'
    end
  end
  # Defines the root path route ("/")
  root "main#index"
end
