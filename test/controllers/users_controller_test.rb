require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! "animalrights.test"
  end

  test "should get new" do
    get signup_url
    assert_response :success
  end
end
