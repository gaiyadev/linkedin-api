Rails.application.routes.draw do
  $user_prefix = "users"
  $post_prefix = 'posts'

  scope "/api" do
    scope '/v1' do
      # Users routes
      post "#$user_prefix/sign_up", to: 'users#sign_up'
      patch "#$user_prefix/verify_email", to: 'users#verify_email'
      post "#$user_prefix/sign_in", to: 'users#sign_in'
      put "#$user_prefix/change_password", to: 'users#change_password'
      get "#$user_prefix/:id", to: 'users#find_by_id'
      post "#$user_prefix/forgot_password", to: 'users#forgot_password'
      put "#$user_prefix/reset_password", to: 'users#reset_password'
      delete "#$user_prefix/:id", to: 'users#destroy'

      # posts
      resources :posts
      get "#$post_prefix/user/:id", to: 'posts#find_by_user_id'
    end
  end
  # Defines the root path route ("/")
  root "main#index"
end
