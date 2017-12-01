require 'test_helper'

class Event::TagTest < ActiveSupport::TestCase
  include ModelInstantiationHelper

  test "should only save if name is present" do
    # Test without name
    t = new_event_tag name: nil
    assert_invalid t, name: :blank

    # Test with empty name
    t.name = ""
    assert_invalid t, name: :blank

    # Test with valid name
    t.name = 'testtag'
    assert t.save
  end

  test "should not save with duplicate name" do
    t1 = new_event_tag
    t2 = new_event_tag
    assert t1.save
    assert_invalid t2, name: :taken
  end

  test "should only save if icon url is present" do
    # Test without icon url
    t = new_event_tag icon_url: nil
    assert_invalid t, icon_url: :blank

    # Test with empty icon url
    t.icon_url = ""
    assert_invalid t, icon_url: :blank

    # Test with valid icon url
    t.icon_url = "events/tags/testtag.png"
    assert t.save
  end

  test "should only save with valid color" do
    # Test without color
    t = new_event_tag color: nil
    assert_invalid t, color: :blank

    # Test with empty color
    t.color = ""
    assert_invalid t, color: :blank

    # Test with too short color
    t.color = "00f30"
    assert_invalid t, color: :wrong_length

    # Test with too long color
    t.color = "00f30f5"
    assert_invalid t, color: :wrong_length

    # Test with invalid character
    t.color = "0f00ga"
    assert_invalid t, color: :invalid_characters

    # Test with valid color
    t.color = "0f80aa"
    assert t.save
  end

  test "should interact with events" do
    # Create event and tag
    e = new_event
    t = new_event_tag
    assert e.save

    # Test successful tag assignment
    assert t.new_record?
    assert e.tags << t
    assert_not t.new_record?
    e = Event.find e.id
    assert e.tags.include?(t)

    # Test successful event removal
    t = Event::Tag.find t.id
    t.events.clear
    assert e.tags.empty?
  end

  test "should prevent duplicates" do
    # Create event and tag
    e = new_event
    t = new_event_tag

    # Test adding tag first time
    e.tags << t
    assert e.save

    # Test adding tag second time
    assert_raises ActiveRecord::RecordNotUnique do
      e.tags << t
    end
  end
end
