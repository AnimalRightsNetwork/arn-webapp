require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! "animalrights.test"
  end

  test "should get index" do
    get events_url
    assert_response :success
  end

  test "should get org event index" do
    get org_events_url(Org.first)
    assert_response :success
  end

  test "should get map" do
    get map_events_url
    assert_response :success
  end

  test "should get org event map" do
    get map_org_events_url(Org.first)
    assert_response :success
  end

  test "should get calendar" do
    get calendar_events_url
    assert_response :success
  end

  test "should get org event calendar" do
    get calendar_org_events_url(Org.first)
    assert_response :success
  end

  test "should get show" do
    get event_url(Event.first)
    assert_response :success
  end

  test "should get new" do
    get new_event_url
    assert_response :success
  end

  test "should get org event new" do
    get new_org_event_url(Org.first)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_url(Event.first)
    assert_response :success
  end
end
