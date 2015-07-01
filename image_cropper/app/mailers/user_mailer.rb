class UserMailer < ApplicationMailer
  def registration_confirmation(user, password)
    @user = user
    @password = password
    mail(:to => user.email, :subject => "Confirmed for registration")
  end
end
