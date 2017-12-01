require 'test_helper'

class Event::TypeTest < ActiveSupport::TestCase
  include ModelInstantiationHelper

  test "should only save with name and icon url" do
    # Test without attributes
    t = new_event_type name: nil, icon_url: nil
    assert_invalid t, name: :blank, icon_url: :blank

    # Test without name
    t.name = nil
    t.icon_url = 'event_types/testtype.png'
    assert_invalid t, name: :blank

    # Test without icon url
    t.name = 'testtype'
    t.icon_url = nil
    assert_invalid t, icon_url: :blank

    # Test with attributes
    t.name = 'testtype'
    t.icon_url = 'event_types/testtype.png'
    assert t.save
  end

  test "should enforce name uniqueness" do
    t1 = new_event_type name: 'uniquename'
    t2 = new_event_type name: 'uniquename'
    assert t1.save
    assert_invalid t2, name: :taken
  end

  test "should not destroy if associated with event" do
    t = new_event_type name: 'indestructable'
    e = new_event type: t
    assert t.save
    assert e.save
    assert_not t.destroy
    assert e.destroy
    assert t.destroy
  end
end
