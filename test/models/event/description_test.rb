require 'test_helper'

class Event::DescriptionTest < ActiveSupport::TestCase
  test "should only save with available language" do
    return # TODO Remove when event is setup
    # Test description without language
    d = Event::Description.new content: "Test content", event: events(:event1)
    assert_not d.save
    assert_not_empty d.errors[:language]

    # Test invalid language
    d.language = 'gazorpazorp'
    assert_not d.save
    assert_not_empty d.errors[:language]

    # Test valid language
    d.language = I18n.available_locales[-1].to_s
    assert d.save
  end

  test "should only save with valid content" do
    return # TODO Remove when event is setup
    # Test without content
    d = Event::Description.new language: I18n.available_locales[-1].to_s, event: events(:event2)
    assert_not d.save
    assert_not_empty d.errors[:content]

    # Test with empty content
    d.content = ""
    assert_not d.save
    assert_not_empty d.errors[:content]

    # Test with too long content
    d.content = "Hello" * 5000 + "."
    assert_not d.save
    assert_not_empty d.errors[:content]

    # Test upper limit
    d.content = "Hello" * 5000
    assert d.save

    # Test lower limit
    d.content = "H"
    assert d.save
  end

  test "should enforce uniqueness of language per event" do
    return # TODO Remove when event is setup
    # Create descriptions
    language1 = I18n.available_locales[0]
    language2 = I18n.available_locales[-1]
    d1 = Event::Description.new language: language1, content: "Test1", event: events(:event1)
    d2 = Event::Description.new language: language1, content: "Test2", event: events(:event1)

    # Test same language and same event
    assert d1.save
    assert_not d2.save
    assert_not_empty d2.errors[:language]

    # Test different languages and same event
    d2.language = language2
    assert d2.save

    # Test same language 
    d2.language = language1
    d2.event = events(:event2)
    assert d2.save
  end

  test "should change updated_at timestamp on event model" do
    return # TODO Remove when event is setup
    # Get event and description
    event = events(:event1)
    description = event.descriptions.first

    # Change description
    assert_difference 'event.updated_at' do
      description.content = "Some other content"
      assert description.save
    end
  end
end
