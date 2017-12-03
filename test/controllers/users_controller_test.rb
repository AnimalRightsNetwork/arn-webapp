require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper
  include ModelInstantiationHelper

  setup do
    host! "animalrights.test"
  end

  test "should get new" do
    get signup_url
    assert_response :success
    assert_select 'form.new_user'
  end

  test "should create user once" do
    # Post first time
    assert_enqueued_emails 1 do
      assert_difference 'User.count', 1 do
        post signup_url, params: {
          user: {
            display_id: 'TestUser',
            email: 'TestUser@test.com',
            password: "Passw0rd",
            password_confirmation: "Passw0rd"
          }
        }
      end
      assert_redirected_to root_url
      assert_includes flash.keys, "success"
    end

    # Post second time with email duplicate
    # Page should act as if new user was created
    assert_no_enqueued_emails do
      assert_no_difference 'User.count' do
        post signup_url, params: {
          user: {
            display_id: 'OtherUser',
            email: 'TestUser@test.com',
            password: "Passw0rd",
            password_confirmation: "Passw0rd"
          }
        }
      end
    end
    assert_redirected_to root_url
    assert_includes flash.keys, "success"

    # Post same user second time
    assert_enqueued_emails 0 do
      assert_no_difference 'User.count' do
        post signup_url, params: {
          user: {
            display_id: 'TestUser',
            email: 'TestUser@test.com',
            password: "Passw0rd",
            password_confirmation: "Passw0rd"
          }
        }
      end
    end
    assert_response :success
    assert_select 'form.new_user'

    # Destroy user for further tests
    User.destroy('testuser')
  end

  test "should get activation" do
    # Create user
    u = new_user(display_id: 'TestUser')
    assert u.save
    
    # Get according activation page
    get user_activation_url(u.display_id, u.activation_token)
    assert_response :success

    # Destroy user for further tests
    u.destroy
  end

  test "should activate once" do
    # Create user
    u = new_user(display_id: 'TestUser')
    assert u.save

    # Post first time
    assert_not u.activated?
    post activate_user_url(u.display_id), params: { token: u.activation_token }
    assert_redirected_to login_url
    assert_includes flash.keys, 'success'
    assert u.reload.activated?

    # Post second time
    post activate_user_url(u.display_id), params: { token: u.activation_token }
    assert_redirected_to root_url
    assert_includes flash.keys, 'error'

    # Destroy user for further tests
    u.destroy
  end
end
