require 'test_helper'

class OrgTest < ActiveSupport::TestCase
  test "should only save valid organization ids" do
    # Test no id
    o = Org.new(default_options.merge name: "ID Test 1")
    assert_not o.save
    assert_not_empty o.errors[:id]

    ## Test too short id
    o = Org.new(default_options.merge id: 'sht', display_id: 'Sht', name: "ID Test 2")
    assert_not o.save
    assert_not_empty o.errors[:id]

    # Test too long id
    o = Org.new(default_options.merge id: 'a' * 31, display_id: 'A' * 31, name: "ID Test 3")
    assert_not o.save
    assert_not_empty o.errors[:id]
    
    # Test lower limit
    o = Org.new(default_options.merge id: 'abcd', display_id: 'Abcd', name: "ID Test 4")
    assert o.save

    # Test upper limit
    o = Org.new(default_options.merge id: 'a' * 30, display_id: 'A' * 30, name: "ID Test 5")
    assert o.save

    # Test invalid character
    o = Org.new(default_options.merge id: 'HelloYou', display_id: 'HelloYou', name: "ID Test 6")
    assert_not o.save
    assert_not_empty o.errors[:id]
  end

  test "should enforce id uniqueness" do
    o1 = Org.new(default_options.merge id: 'duplicate', display_id: 'Duplicate', name: "ID Test 7")
    o2 = Org.new(default_options.merge id: 'duplicate', display_id: 'DupliCate', name: "ID Test 8")
    assert o1.save
    assert_not o2.save
    assert_not_empty o2.errors[:id]
  end

  test "should not save if id and display_id don't match" do
    o = Org.new(default_options.merge id: 'displayidtest', display_id: 'DisplayId')
    assert_not o.save
    assert_not_empty o.errors[:display_id]
  end


  test "should not save without type" do
    # Test without type
    o = Org.new(
      default_options.merge id: 'typeless', display_id: 'Typeless', name: "Typeless", type: nil
    )
    assert_not o.save
    assert_not_empty o.errors[:type]
  end

  test "should not save without image" do
    # Test without logo url
    o = Org.new default_options.merge(
      id: 'imageless', display_id: 'Imageless', name: "Imageless", logo_url: nil
    )
    assert_not o.save
    assert_not_empty o.errors[:logo_url]

    # Test without cover url
    o = Org.new default_options.merge(
      id: 'imageless', display_id: 'Imageless', name: "Imageless", cover_url: nil
    )
    assert_not o.save
    assert_not_empty o.errors[:cover_url]
    
    # Test without marker url
    o = Org.new default_options.merge(
      id: 'imageless', display_id: 'Imageless', name: "Imageless", marker_url: nil
    )
    assert_not o.save
    assert_not_empty o.errors[:marker_url]
  end

  test "should not save without valid color" do
    # Test without marker color
    o = Org.new default_options.merge(
      id: 'colorless', display_id: 'Colorless', name: "Colorless", marker_color: nil
    )
    assert_not o.save
    assert_not_empty o.errors[:marker_color]

    # Test without too short marker color
    o = Org.new default_options.merge(
      id: 'colorless', display_id: 'Colorless', name: "Colorless", marker_color: "000"
    )
    assert_not o.save
    assert_not_empty o.errors[:marker_color]

    # Test without invalid characters
    o = Org.new default_options.merge(
      id: 'colorless', display_id: 'Colorless', name: "Colorless", marker_color: "yellow"
    )
    assert_not o.save
    assert_not_empty o.errors[:marker_color]
  end

  test "should not destroy type if associated with organization" do
    t = Org::Type.new name: 'association', icon_url: 'org_types/association.png'
    o = Org.new(default_options.merge id: 'typed', display_id: 'Typed', name: "Typed", type: t)
    assert t.save
    assert o.save
    assert_not t.destroy
    assert o.destroy
    assert t.destroy
  end

  def default_options
    {
      type: org_types(:group),
      logo_url: "logos/image.png",
      cover_url: "covers/image.png",
      marker_url: "markers/image.png",
      marker_color: "000000"
    }
  end
end
