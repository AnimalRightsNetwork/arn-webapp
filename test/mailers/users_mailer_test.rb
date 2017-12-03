require 'test_helper'

class UsersMailerTest < ActionMailer::TestCase
  test "signup" do
    user = User.create(
      display_id: "EmailTest",
      email: "emailtest@example.com",
      password: "Passw0rd",
      password_confirmation: "Passw0rd"
    )
    mail = UsersMailer.signup user, user.activation_token
    assert_equal I18n.t('users_mailer.signup.subject'), mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["hello@animalrights.network"], mail.from
  end

end
