require 'test_helper'

class Org::LinkTest < ActiveSupport::TestCase
  include ModelInstantiationHelper

  test "Should only save with url" do
    # Test without url
    l = new_org_link url: nil, org: new_org
    assert_invalid l, url: :blank

    # Test empty url
    l.url = ""
    assert_invalid l, url: :blank

    # Test with url
    l.url = "https://test.com"
    assert l.save
  end

  test "should not save without organization or type" do
    # Test without organization
    l = new_org_link org: nil
    assert_invalid l, org: :blank

    # Test without link type
    l = new_org_link link_type: nil
    assert_invalid l, link_type: :blank
  end

  test "should enforce type uniqueness per organization" do
    # Create links, types and organizations
    t1 = new_link_type name: 'testtype1'
    t2 = new_link_type name: 'testtype2'
    o1 = new_org display_id: "Org1", name: "Organization 1"
    o2 = new_org display_id: "Org2", name: "Organization 2"
    l1 = new_org_link link_type: t1, url: "http://test1.com"
    l2 = new_org_link link_type: t1, url: "http://test2.com"

    # Test same type and same organization
    o1.links << l1
    assert o1.save
    o1.links << l2
    assert_invalid o1

    # Test different type and same organization
    l2.link_type = t2
    assert o1.save
  end
end
