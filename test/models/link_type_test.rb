require 'test_helper'

class LinkTypeTest < ActiveSupport::TestCase
  test "should only save if name is present" do
    # Test without name
    t = new_link_type name: nil
    assert_invalid t, name: :blank

    # Test with empty name
    t.name = ""
    assert_invalid t, name: :blank

    # Test with valid name
    t.name = 'testtype'
    assert t.save
  end

  test "should not save with duplicate name" do
    t1 = new_link_type
    t2 = new_link_type
    assert t1.save
    assert_invalid t2, name: :taken
  end

  test "should only save if icon url is present" do
    # Test without icon url
    t = new_link_type icon_url: nil
    assert_invalid t, icon_url: :blank

    # Test with empty icon url
    t.icon_url = ""
    assert_invalid t, icon_url: :blank

    # Test with valid icon url
    t.icon_url = "link_types/testtype.png"
    assert t.save
  end

  # Create link type with defaults
  def new_link_type params={}
    LinkType.new({
      name: 'testtype',
      icon_url: "link_types/testtype.png",
    }.merge(params))
  end
end
