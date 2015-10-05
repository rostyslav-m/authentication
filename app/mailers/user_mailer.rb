class UserMailer < ApplicationMailer

default from: 'notifications@authentication.com'
 
  def welcome_email(user)
    @user = user
    @url  = 'http://authentication.com/log_in'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
  
end
