class UserMailer < ApplicationMailer
default from: 'noreply@example.com'

  def email_verification
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Email verification')
  end
end
