require 'test_helper'

class Orgs::TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! "animalrights.test"
  end

  test "should get index" do
    get orgs_tags_url
    assert_response :success
  end

  test "should get new" do
    get new_orgs_tag_url
    assert_response :success
  end

  test "should get edit" do
    get edit_orgs_tag_url(Org::Tag.first)
    assert_response :success
  end
end
