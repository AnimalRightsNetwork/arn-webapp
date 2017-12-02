require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! "animalrights.test"
  end

  test "should get new" do
    get login_url
    assert_response :success
  end
end
