require 'test_helper'

class OrgTest < ActiveSupport::TestCase
  include ModelInstantiationHelper

  test "should only save valid organization ids" do
    # Test no id
    o = new_org display_id: nil
    assert_invalid o, id: :blank

    ## Test too short id
    o.display_id = 'Sht'
    assert_invalid o, id: :too_short

    # Test too long id
    o.display_id = 'A' * 33
    assert_invalid o, id: :too_long
    
    # Test lower limit
    o = new_org display_id: 'Abcd', name: "Lower"
    assert o.save

    # Test upper limit
    o = new_org display_id: 'A' * 32, name: "Upper", type: o.type
    assert o.save

    # Test invalid character
    o = new_org display_id: 'Inv^alid'
    assert_invalid o, id: :invalid_characters
  end

  test "should enforce id uniqueness" do
    o1 = new_org display_id: 'Duplicate', name: "Dup 1"
    o2 = new_org display_id: 'DupliCate', name: "Dup 2"
    assert o1.save
    assert_invalid o2, id: :taken
  end

  test "should only make id accessible through display_id" do
    # Test id mass assignment
    assert_raises NoMethodError do new_org(id: 'directassignment') end

    # Test id auto assignment
    o = new_org display_id: "DisplayID"
    assert_equal o.id, o.display_id.downcase

    # Test direct id assignment
    assert_raises NoMethodError do o.id = 'newid' end
  end

  test "should allow subsequent display_id assignment" do
    assert_nothing_raised do
      # Test without display id
      o = new_org display_id: nil
      assert_invalid o, id: :blank

      # Test assigning valid id
      o.display_id = 'ValidID'
      assert o.save
    end
  end

  test "should not save without type" do
    # Test without type
    o = new_org type: nil
    assert_invalid o, type: :blank
  end

  test "should save and destroy descriptions automatically" do
    # Create event with description
    d = new_org_description
    o = new_org descriptions: [d]

    # Test description unsaved before and saved after event save
    assert d.new_record?
    assert o.save
    assert_not d.new_record?

    # Test automatic description deletion
    assert Org::Description.exists?(d.id)
    assert o.destroy
    assert_not Org::Description.exists?(d.id)
  end

  test "should not save without description" do
    o = new_org descriptions: []
    assert_invalid o, descriptions: :empty
  end

  test "should only save with valid name" do
    # Test without name
    o = new_org name: nil
    assert_invalid o, name: :blank

    # Test empty name
    o.name = ""
    assert_invalid o, name: :blank

    # Test too short name
    o.name = "ABC"
    assert_invalid o, name: :too_short

    # Test too long name
    o.name = "A" * 49
    assert_invalid o, name: :too_long

    # Test lower limit
    o.name = "ABCD"
    assert o.save

    # Test upper limit
    o.name = "A" * 48
    assert o.save
  end

  test "should enforce name uniqueness" do
    o1 = new_org display_id: "Unique1", name: "Unique"
    o2 = new_org display_id: "Unique2", name: "Unique"
  end

  test "should not save without image" do
    # Test without image urls
    o = new_org logo_url: nil, cover_url: nil, marker_url: nil
    assert_invalid o, logo_url: :blank, cover_url: :blank, marker_url: :blank
  end

  test "should not save without valid color" do
    # Test without marker color
    o = new_org marker_color: nil
    assert_invalid o, marker_color: :blank

    # Test too short marker color
    o.marker_color = "000"
    assert_invalid o, marker_color: :wrong_length

    # Test with invalid characters
    o.marker_color = "0agf00"
    assert_invalid o, marker_color: :invalid_characters
  end

  test "should interact with admins" do
    # Create organization and user
    o = new_org
    u = new_user
    assert o.save

    # Test successful admin assignment
    assert u.new_record?
    assert o.admins << u
    assert_not u.new_record?
    o = Org.find o.id
    assert o.admins.include?(u)

    # Test successful admin removal
    u = User.find u.id
    u.administrated_orgs.clear
    assert o.admins.empty?
  end

  test "should prevent admin duplicates" do
    # Create organization and user
    o = new_org
    u = new_user

    # Test adding user first time
    o.admins << u
    assert o.save

    # Test adding user second time
    assert_raises ActiveRecord::RecordNotUnique do
      o.admins << u
    end
  end
end
