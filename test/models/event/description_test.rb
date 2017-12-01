require 'test_helper'

class Event::DescriptionTest < ActiveSupport::TestCase
  include ModelInstantiationHelper

  test "should only save with available language" do
    # Test description without language
    d = new_event_description language: nil
    e = new_event descriptions: [d]
    assert_invalid e

    # Test invalid language
    d.language = :gazorpazorp
    assert_invalid e

    # Test valid language
    d.language = I18n.locale
    assert e.save
  end

  test "should only save with valid content" do
    # Test without content
    d = new_event_description content: nil
    e = new_event descriptions: [d]
    assert_invalid e

    # Test with empty content
    d.content = ""
    assert_invalid e

    # Test with too long content
    d.content = "Hello" * 1000 + "."
    assert_invalid e

    # Test upper limit
    d.content = "Hello" * 1000
    assert e.save

    # Test lower limit
    d.content = "H"
    assert e.save
  end

  test "should enforce uniqueness of language per event" do
    # Create descriptions and events
    l1 = I18n.available_locales[0]
    l2 = I18n.available_locales[1]
    d1 = new_event_description language: l1, content: "Test"
    d2 = new_event_description language: l1, content: "Test"
    e1 = new_event descriptions: []
    e2 = new_event descriptions: []

    # Test same language and same event
    e1.descriptions << d1
    assert e1.save
    e1.descriptions << d2
    assert_invalid e1

    # Test different languages and same event
    d2.language = l2
    assert e1.save
  end

  test "should change updated_at timestamp on event model" do
    # Create event and description
    d = new_event_description
    e = new_event descriptions: [d]

    # Save event
    assert e.save

    # Test updated_at change when changing description
    assert_changes 'e.updated_at' do
      d.content = "Some other content"
      d.save
    end
  end
end
