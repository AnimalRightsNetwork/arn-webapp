require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test "should save with and without organization" do
    # Test without org
    e = new_event
    e.org = nil
    assert e.save, "Expected save but failed with #{e.errors.messages}"

    # Test with org
    e.org = orgs(:org1)
    assert e.save
    assert orgs(:org1).reload.events.include?(e)
  end

  test "should not save without type" do
    e = new_event 
    e.type = nil
    assert_invalid e, type: :blank
  end

  test "should save and destroy descriptions automatically" do
    # Create event with description
    d = new_description
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

  test "should not save without start time" do
    e = new_event start_time: nil
    assert_invalid e, start_time: :blank
  end

  test "should not save with empty image url" do
    e = new_event image_url: nil
    assert e.save
    e.image_url = ""
    assert_invalid e, image_url: :blank
  end

  # Create event with defaults
  def new_event params={}
    Event.new({
      descriptions: [new_description],
      type: event_types(:demonstration),
      name: "Test Event",
      start_time: DateTime.now
    }.merge(params))
  end

  # Create event description with defaults
  def new_description params={}
    Event::Description.new({
      language: I18n.locale,
      content: "Dolor veniam cum voluptas ratione nam obcaecati nobis!"
      # Needs to be assigned to an event
    }.merge(params))
  end
end
