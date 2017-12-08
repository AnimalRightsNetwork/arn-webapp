require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! "animalrights.test"
  end

  test "should get new" do
    # Test without login
    get login_url
    assert_response :success
    assert_select 'form'
  end

  test "should login once" do
    # Login Alice
    post login_url, params: {
      session: {
        email: 'Alice@example.com',
        password: "AlicePassw0rd"
      }
    }
    assert_redirected_to root_url
    assert_includes flash.keys, 'success'

    # Test login page when already logged in
    get login_url
    assert_redirected_to root_url
    assert_includes flash.keys, 'warning'

    # Login again
    post login_url, params: {
      session: {
        email: 'Alice@example.com',
        password: "AlicePassw0rd"
      }
    }
    assert_redirected_to root_url
    assert_includes flash.keys, 'success'
  end

  test "should logout if logged in" do
    # Login Alice
    post login_url, params: {
      session: {
        email: 'Alice@example.com',
        password: "AlicePassw0rd"
      }
    }

    # Logout Alice first time
    delete logout_url
    assert_redirected_to root_url
    assert_includes flash.keys, 'success'
    follow_redirect!

    # Logout Alice first time
    delete logout_url
    assert_redirected_to root_url
    assert_not_includes flash.keys, 'success'
  end

  test "Should show error message on wrong credentials" do
    post login_url, params: {
      session: {
        email: 'Wrong@example.com',
        password: 'Passw0rd'
      }
    }
    assert_response :success
    assert_includes flash.keys, 'form_error'
    assert_select '.form-error'
  end
end
