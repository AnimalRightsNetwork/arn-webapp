require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not only save with correct length" do
    # Test id too short
    u = User.create id: 'shrt', password: 'MyPassw0rd', password_confirmation: 'MyPassw0rd'
    assert_not u.save
    assert_not_empty u.errors[:id]

    # Test id too long and invalid characters
    u.id = "this1istolongtoousea5"
    assert_not u.save
    assert_not_empty u.errors[:id]

    # Test lower limit
    u.id = "short"
    assert u.save

    # Test upper limit
    u.id = "this1istolongtoousea"
    assert u.save
  end

  test "should only save with valid characters" do
    # Test invalid characters
    u = User.create id: 'Invalid', password: 'MyPassw0rd', password_confirmation: 'MyPassw0rd'
    assert_not u.save
    assert_not_empty u.errors[:id]

    # Test invalid characters and too short
    u.id = 'Inva'
    assert_not u.save
    assert_not_empty u.errors[:id]

    # Test only valid characters
    u.id = 'valid'
    assert u.save
  end

  test "should only save with valid password and confirmation" do
    # Test without password
    u = User.create id: 'valid'
    assert_not u.save
    assert_not_empty u.errors[:password]

    # Test with too short password
    u.password = u.password_confirmation = 'T00shrt'
    assert_not u.save
    assert_not_empty u.errors[:password]

    # Test with too long password
    u.password = u.password_confirmation = "A0#{'a' * 63}"
    assert_not u.save
    assert_not_empty u.errors[:password]

    # Test lower limit
    u.password = u.password_confirmation = 'L0ngengh'
    assert u.save

    # Test upper limit
    u.password = u.password_confirmation = "A0#{'a' * 62}"
    assert u.save

    # Test without digits
    u.password = u.password_confirmation = "NoDigitsAtAll"
    assert_not u.save
    assert_not_empty u.errors[:password]

    # Test missing confirmation
    u.password = "MyPassw0rd"
    u.password_confirmation = nil
    assert_not u.save
    assert_empty u.errors[:password]
    assert_not_empty u.errors[:password_confirmation]

    # Test not matching
    u.password = (u.password_confirmation = "MyPassw0rd") + "a"
    assert_not u.save
    assert_empty u.errors[:password]
    assert_not_empty u.errors[:password_confirmation]
  end

  test "should enforce uniqueness on user id" do
    u1 = User.new id: 'uniqueid', password: 'MyPassw0rd', password_confirmation: 'MyPassw0rd'
    u2 = User.new id: 'uniqueid', password: 'MyPassw0rd', password_confirmation: 'MyPassw0rd'
    assert u1.save
    assert_not u2.save
    assert_not_empty u2.errors[:id]
  end
end
