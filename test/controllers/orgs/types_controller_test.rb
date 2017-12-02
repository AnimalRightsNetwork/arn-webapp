require 'test_helper'

class Orgs::TypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! "animalrights.test"
  end

  test "should get index" do
    get orgs_types_url
    assert_response :success
  end

  test "should get new" do
    get new_orgs_type_url
    assert_response :success
  end

  test "should get edit" do
    get edit_orgs_type_url(Org::Type.first)
    assert_response :success
  end

end
