require 'test_helper'

class SearchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! "animalrights.test"
  end

  test "should get index" do
    get search_url
    assert_response :success
  end
end
