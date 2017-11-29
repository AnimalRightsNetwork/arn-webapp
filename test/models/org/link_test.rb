require 'test_helper'

class Org::LinkTest < ActiveSupport::TestCase
  test "Should only save with url" do
    # Test without url
    l = new_link url: nil
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
    l = new_link org: nil
    assert_invalid l, org: :blank

    # Test without link type
    l = new_link link_type: nil
    assert_invalid l, link_type: :blank
  end

  test "should enforce type uniqueness per organization" do
    # Create links, types and organizations
    t1 = new_type name: 'testtype1'
    t2 = new_type name: 'testtype2'
    o1 = new_org display_id: "Org1", name: "Organization 1"
    o2 = new_org display_id: "Org2", name: "Organization 2"
    l1 = new_link link_type: t1, url: "http://test1.com"
    l2 = new_link link_type: t1, url: "http://test2.com"

    # Test same type and same organization
    o1.links << l1
    assert o1.save
    o1.links << l2
    assert_invalid o1

    # Test different type and same organization
    l2.link_type = t2
    assert o1.save
  end

  # Create link with defaults
  def new_link params={}
    Org::Link.new({
      org: Org.last,
      link_type: LinkType.last,
      url: "https://test.com/"
    }.merge(params))
  end

  # Create link type with defaults
  def new_type params={}
    LinkType.new({
      name: 'testtype',
      icon_url: "link_types/testtype.png",
    }.merge(params))
  end

  # Create organization with defaults
  def new_org params={}
    Org.new({
      display_id: "TestOrganization",
      type: Org::Type.find_by(name: :association),
      name: "Test Organization",
      logo_url: "orgs/logos/testorg2.png",
      cover_url: "orgs/covers/testorg2.jpg",
      marker_url: "orgs/markers/testorg2.png",
      marker_color: '000000',
      descriptions: [new_description]
    }.merge(params))
  end

  # Create organization description with defaults
  def new_description params={}
    Org::Description.new({
      language: I18n.locale,
      content: "Dolor veniam cum voluptas ratione nam obcaecati nobis!"
      # Needs to be assigned to an organization
    }.merge(params))
  end
end
