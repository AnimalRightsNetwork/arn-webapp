require 'test_helper'

class Events::TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! "animalrights.test"
  end

  test "should get index" do
    get events_tags_url
    assert_response :success
  end

  test "should get new" do
    get new_events_tag_url
    assert_response :success
  end

  test "should get edit" do
    get edit_events_tag_url(Event::Tag.first)
    assert_response :success
  end
end
