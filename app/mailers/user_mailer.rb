class UserMailer < ApplicationMailer
default from: 'noreply@linkedinclone.com'

  def email_verification
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Email Verification')
  end
end
