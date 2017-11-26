require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! 'animalrights.test'
  end

  test "should get home" do
    get root_url
    assert_response :success
    assert_select 'body.static_pages-home'
    assert_select "img#image-logo"
  end
end
