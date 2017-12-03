class UsersMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/users_mailer/signup
  def signup
    user = User.create(
      display_id: "EmailTest",
      email: "emailtest@example.com",
      password: "Passw0rd",
      password_confirmation: "Passw0rd"
    )
    mailer = UsersMailer.signup user, user.activation_token
    user.destroy
    mailer
  end
end
