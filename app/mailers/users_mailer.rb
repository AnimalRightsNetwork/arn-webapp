class UsersMailer < ApplicationMailer
  def signup user, activation_token
    @user = user
    @activation_token = activation_token
    mail to: @user.email
  end
end
