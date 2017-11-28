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

  test "should only save without or with non empty facebook url" do
    # Create event
    e = new_event fb_url: nil

    # Test without facebook url
    assert e.save

    # Test with empty facebook url
    e.fb_url = ""
    assert_invalid e, fb_url: :blank

    # Test with non empty facebook url
    e.fb_url = "/TheAnimalRightsNet/events/tests_event"
    assert e.save
  end

  test "should interact with tags" do
    # Create event and tag
    e = new_event
    t = new_tag
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

  test "should prevent event tag duplicates" do
    # Create event and tag
    e = new_event
    t = new_tag

    # Test adding tag first time
    e.tags << t
    assert e.save

    # Test adding tag second time
    assert_raises ActiveRecord::RecordNotUnique do
      e.tags << t
    end
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

  # Create event tag with defaults
  def new_tag params={}
    Event::Tag.new({
      name: 'testtag',
      icon_url: "events/tags/graphic.png",
      color: 'ff8000'
    }.merge(params))
  end
end
