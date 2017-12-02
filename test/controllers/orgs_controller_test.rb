require 'test_helper'

class OrgsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! "animalrights.test"
  end

  test "should get index" do
    get orgs_url
    assert_response :success
  end

  test "should get show" do
    get org_url(Org.first)
    assert_response :success
  end

  test "should get new" do
    get new_org_url
    assert_response :success
  end

  test "should get edit" do
    get edit_org_url(Org.first)
    assert_response :success
  end
end
