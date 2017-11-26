require 'test_helper'

class Org::TypeTest < ActiveSupport::TestCase
  test "should only save with name and icon url" do
    # Test without attributes
    t = Org::Type.new
    assert_not t.save
    assert_not_empty t.errors[:name]
    assert_not_empty t.errors[:icon_url]

    # Test without name
    t.name = nil
    t.icon_url = 'org_types/association.png'
    assert_not t.save
    assert_not_empty t.errors[:name]

    # Test without icon url
    t.name = 'association'
    t.icon_url = nil
    assert_not t.save
    assert_not_empty t.errors[:icon_url]

    # Test with attributes
    t.name = 'association'
    t.icon_url = 'org_types/association.png'
    assert t.save
  end

  test "should enforce name uniqueness" do
    t1 = Org::Type.new name: 'party', icon_url: 'org_types/party.png'
    t2 = Org::Type.new name: 'party', icon_url: 'org_types/parties.png'
    assert t1.save
    assert_not t2.save
    assert_not_empty t2.errors[:name]
  end
end
