require 'test_helper'

class Event::TypeTest < ActiveSupport::TestCase
  test "should not save without both attributes" do
    # Create without attributes
    t = Event::Type.new
    assert_not t.save
    assert_not_empty t.errors[:name]
    assert_not_empty t.errors[:icon_url]

    # Set attributes
    t.name = "temporary"
    t.icon_url = "icons/temporary"
    assert t.save
  end
end
