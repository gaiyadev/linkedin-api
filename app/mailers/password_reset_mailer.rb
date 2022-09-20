class PasswordResetMailer < ApplicationMailer
    def password_reset
    @user = params[:user]
    reset_token = params[:reset_token]
    @url  = 'http://localhost:3000/reset-password/'+reset_token.to_s
    mail(to: @user.email, subject: 'Password Recovery')
  end
end
