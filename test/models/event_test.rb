require 'test_helper'

class EventTest < ActiveSupport::TestCase
  include ModelInstantiationHelper

  test "should save with and without organization" do
    # Test without org
    e = new_event org: nil
    assert e.save

    # Test with org
    o = new_org
    o.save
    e.org = o
    assert e.save
    assert_includes o.reload.events, e
  end

  test "should not save without type" do
    e = new_event type: nil
    assert_invalid e, type: :blank
  end

  test "should only save with valid name" do
    # Test without name
    e = new_event name: nil
    assert_invalid e, name: :blank

    # Test with empty name
    e.name = ""
    assert_invalid e, name: :blank

    # Test with too short name
    e.name = "Srt"
    assert_invalid e, name: :too_short

    # Test with too long name
    e.name = "A" * 65
    assert_invalid e, name: :too_long

    # Test lower limit
    e.name = "Lowe"
    assert e.save

    # Test upper limit
    e.name = "A" * 64
    assert e.save
  end

  test "should not save with empty image url" do
    # Test without image url
    e = new_event image_url: nil
    assert e.save

    # Test with empty image url
    e.image_url = ""
    assert_invalid e, image_url: :blank

    # Test with valid image url
    e.image_url = "events/images/0.png"
    assert e.save
  end

  test "should not save without start time" do
    e = new_event start_time: nil
    assert_invalid e, start_time: :blank
  end

  test "should not save with empty facebook url" do
    return
    # Test without facebook url
    e = new_event fb_url: nil
    assert e.save

    # Test with empty facebook url
    e.fb_url = ""
    assert_invalid e, fb_url: :blank

    # Test with valid facebook url
    e.fb_url = "/TheAnimalRightsNet/events/tests_event"
    assert e.save
  end

  test "should save and destroy descriptions automatically" do
    # Create event with description
    d = new_event_description
    e = new_event descriptions: [d]

    # Test description unsaved before and saved after event save
    assert d.new_record?
    assert e.save
    assert_not d.new_record?

    # Test automatic description deletion
    assert Event::Description.exists?(d.id)
    assert e.destroy
    assert_not Event::Description.exists?(d.id)
  end

  test "should not save without description" do
    e = new_event descriptions: []
    assert_invalid e, descriptions: :empty
  end
end
