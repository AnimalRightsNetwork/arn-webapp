require 'test_helper'

class Events::TypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! "animalrights.test"
  end

  test "should get index" do
    get events_types_url
    assert_response :success
  end

  test "should get new" do
    get new_events_type_url
    assert_response :success
  end

  test "should get edit" do
    get edit_events_type_url(Event::Type.first)
    assert_response :success
  end
end
