require 'test_helper'

class Org::TypeTest < ActiveSupport::TestCase
  include ModelInstantiationHelper

  test "should only save with name and icon url" do
    # Test without attributes
    t = new_org_type name: nil, icon_url: nil
    assert_invalid t, name: :blank, icon_url: :blank

    # Test without name
    t.name = nil
    t.icon_url = 'org_types/testtype.png'
    assert_invalid t, name: :blank

    # Test without icon url
    t.name = 'testtype'
    t.icon_url = nil
    assert_invalid t, icon_url: :blank

    # Test with attributes
    t.name = 'testtype'
    t.icon_url = 'org_types/testtype.png'
    assert t.save
  end

  test "should enforce name uniqueness" do
    t1 = new_org_type name: 'uniquename'
    t2 = new_org_type name: 'uniquename'
    assert t1.save
    assert_invalid t2, name: :taken
  end

  test "should not destroy if associated with org" do
    t = new_org_type name: 'indestructable'
    o = new_org type: t
    assert t.save
    assert o.save
    assert_not t.destroy
    assert o.destroy
    assert t.destroy
  end
end
