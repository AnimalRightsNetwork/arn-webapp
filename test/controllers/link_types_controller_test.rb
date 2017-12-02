require 'test_helper'

class LinkTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! "animalrights.test"
  end

  test "should get index" do
    get link_types_url
    assert_response :success
  end

  test "should get new" do
    get new_link_type_url
    assert_response :success
  end

  test "should get edit" do
    get edit_link_type_url(LinkType.first)
    assert_response :success
  end
end
