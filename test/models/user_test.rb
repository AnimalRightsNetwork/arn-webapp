require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include ModelInstantiationHelper

  test "should only save with correct id length" do
    # Test id too short
    u = new_user display_id: 'Shrt'
    assert_invalid u, id: :too_short

    # Test id too long
    u.display_id = 'This1IsTooLongToUseAsAName'
    assert_invalid u, id: :too_long

    # Test lower limit
    u.display_id = 'Short'
    assert u.save

    # Test upper limit
    u.display_id = 'ThisIsNotTooLongToUseAsNa'
    assert u.save
  end

  test "should only save with valid characters" do
    # Test invalid characters
    u = new_user display_id: 'Invalid.'
    assert_invalid u, id: :invalid_characters

    # Test invalid characters and too short
    u.display_id = 'In^4'
    assert_invalid u, id: :invalid_characters

    # Test only valid characters
    u.display_id = 'Valid'
    assert u.save
  end

  test "should only save with valid password and confirmation" do
    # Test without password
    u = new_user password: nil, password_confirmation: nil
    assert_invalid u, password: :blank

    # Test with too short password
    u.password = u.password_confirmation = "T00shrt"
    assert_invalid u, password: :too_short

    # Test with too long password
    u.password = u.password_confirmation = "A0#{'a' * 63}"
    assert_invalid u, password: :too_long

    # Test lower limit
    u.password = u.password_confirmation = "L0ngengh"
    assert u.save

    # Test upper limit
    u.password = u.password_confirmation = "A0#{'a' * 62}"
    assert u.save

    # Test without digits
    u.password = u.password_confirmation = "NoDigitsAtAll"
    assert_invalid u, password: :insufficient_complexity

    # Test missing confirmation
    u.password = "MyPassw0rd"
    u.password_confirmation = nil
    assert_invalid u, password_confirmation: :blank
    assert_empty u.errors[:password]

    # Test not matching
    u.password = (u.password_confirmation = "MyPassw0rd") + "a"
    assert_invalid u, password_confirmation: :confirmation
    assert_empty u.errors[:password]

    # Test only confirmation
    u.password = nil
    u.password_confirmation = "MyPassw0rd"
    assert_invalid u, password: :blank
  end

  test "should save without new password" do
    # Create valid user
    u = new_user display_id: 'Saved'
    u.save

    # Reload user and change id
    u = User.find 'saved'
    u.display_id = 'SavedAgain'

    # Save without new password
    assert_nil u.password
    assert_nil u.password_confirmation
    assert u.save
  end

  test "should enforce uniqueness on user id" do
    u1 = new_user display_id: 'UniqueID'
    u2 = new_user display_id: 'UNIQUEID'
    assert u1.save
    assert_invalid u2, id: :taken
  end

  test "should only save with valid email address" do
    # Test without email
    u = new_user email: nil
    assert_invalid u, email: :blank

    # Test with invalid email
    u.email = "invalid@email"
    assert_invalid u, email: :invalid_email_address
  end

  test "should enforce uniqueness on email" do
    u1 = new_user display_id: 'Unique1', email: "unique@test.com"
    u2 = new_user display_id: 'Unique2', email: "unique@test.com"
    assert u1.save
    assert_invalid u2, email: :taken
  end

  test "should only make activation_digest writable through 'save' and 'activate'" do
    # Create user
    u = new_user display_id: 'Activation'
    
    # Test unspecified tokens
    assert_nil u.activation_token
    assert_nil u.activation_digest

    # Test private setters
    assert_raises NoMethodError do u.activation_token = "hello" end
    assert_raises NoMethodError do u.activation_digest = "hello" end

    # Test generation of tokens
    assert u.save
    assert_not_nil token = u.activation_token
    assert_not_nil u.activation_digest

    # Reload user
    u = User.find 'activation'

    # Test user not being activated by default
    assert_not u.activated?

    # Test user activation
    assert_not u.activate "invalid token"
    assert_equal u, u.activate(token)

    # Test user being activated after activation
    assert u.activated?
  end
end
