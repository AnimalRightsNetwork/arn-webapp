class SessionsHelperTest < ActionView::TestCase
  test "should log in and out correctly" do
    # Get users
    u1 = User.first
    u2 = User.second

    # No user logged in
    assert_not logged_in?
    assert_not current_user? u1
    assert_nil current_user
    assert_not log_out
    
    # Log in user 1
    log_in u1
    assert logged_in?
    assert current_user? u1
    assert_equal u1, current_user

    # Log in user 2
    log_in u2
    assert logged_in?
    assert current_user? u2
    assert_not current_user? u1
    assert_equal u2, current_user

    # Log out user
    assert log_out
    assert_not logged_in?
    assert_not current_user? u2
    assert_nil current_user
    assert_not log_out
  end
end
