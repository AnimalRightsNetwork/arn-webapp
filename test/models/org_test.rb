require 'test_helper'

class OrgTest < ActiveSupport::TestCase
  test "should only save valid organization ids" do
    # Test no id
    o = Org.new(default_options.merge name: "ID Test 1")
    assert_not o.save
    assert_not_empty o.errors[:id]

    ## Test too short id
    o = Org.new(default_options.merge display_id: 'Sht', name: "ID Test 2")
    assert_not o.save
    assert_not_empty o.errors[:id]

    # Test too long id
    o = Org.new(default_options.merge display_id: 'A' * 33, name: "ID Test 3")
    assert_not o.save
    assert_not_empty o.errors[:id]
    
    # Test lower limit
    o = Org.new(default_options.merge display_id: 'Abcd', name: "ID Test 4")
    assert o.save

    # Test upper limit
    o = Org.new(default_options.merge display_id: 'A' * 32, name: "ID Test 5")
    assert o.save

    # Test invalid character
    o = Org.new(default_options.merge display_id: 'Hello You', name: "ID Test 6")
    assert_not o.save
    assert_not_empty o.errors[:id]
  end

  test "should enforce id uniqueness" do
    o1 = Org.new(default_options.merge display_id: 'Duplicate', name: "ID Test 7")
    o2 = Org.new(default_options.merge display_id: 'DupliCate', name: "ID Test 8")
    assert o1.save
    assert_not o2.save
    assert_not_empty o2.errors[:id]
  end

  test "should only make id accessible through display_id" do
    # Test id mass assignment
    assert_raises NoMethodError do
      o = Org.new(default_options.merge id: 'displayid', display_id: "DisplayID", name: "ID Test 9")
    end

    # Test id auto assignment
    o = Org.new(default_options.merge display_id: 'DisplayId', name: "ID Test 10")
    assert_equal o.id, o.display_id.downcase

    # Test direct id assignment
    assert_raises NoMethodError do
      o.id = 'newid'
    end
  end

  test "should allow subsequent display_id assignment" do
    assert_nothing_raised do
      # Test without display id
      o = Org.new(default_options.merge name: "ID Test 11")
      assert_not o.save
      assert_not_empty o.errors[:id]

      # Test assigning nil
      o.display_id = nil
      assert_not o.save
      assert_not_empty o.errors[:id]

      # Test assigning valid id
      o.display_id = 'ValidID'
      assert o.save
    end
  end

  test "should not save without type" do
    # Test without type
    o = Org.new(
      default_options.merge display_id: 'Typeless', name: "Typeless", type: nil
    )
    assert_not o.save
    assert_not_empty o.errors[:type]
  end

  test "should save and destroy descriptions automatically" do
    # Create event with description
    d = new_description
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

  test "should not save without image" do
    # Test without logo url
    o = Org.new default_options.merge(
      display_id: 'Imageless', name: "Imageless", logo_url: nil
    )
    assert_not o.save
    assert_not_empty o.errors[:logo_url]

    # Test without cover url
    o = Org.new default_options.merge(
      display_id: 'Imageless', name: "Imageless", cover_url: nil
    )
    assert_not o.save
    assert_not_empty o.errors[:cover_url]
    
    # Test without marker url
    o = Org.new default_options.merge(
      display_id: 'Imageless', name: "Imageless", marker_url: nil
    )
    assert_not o.save
    assert_not_empty o.errors[:marker_url]
  end

  test "should not save without valid color" do
    # Test without marker color
    o = Org.new default_options.merge(
      display_id: 'Colorless', name: "Colorless", marker_color: nil
    )
    assert_not o.save
    assert_not_empty o.errors[:marker_color]

    # Test without too short marker color
    o = Org.new default_options.merge(
      display_id: 'Colorless', name: "Colorless", marker_color: "000"
    )
    assert_not o.save
    assert_not_empty o.errors[:marker_color]

    # Test without invalid characters
    o = Org.new default_options.merge(
      display_id: 'Colorless', name: "Colorless", marker_color: "yellow"
    )
    assert_not o.save
    assert_not_empty o.errors[:marker_color]
  end

  test "should not destroy type if associated with organization" do
    t = Org::Type.new name: 'undestructable', icon_url: 'org_types/undestructable.png'
    o = Org.new(default_options.merge display_id: 'Typed', name: "Typed", type: t)
    assert t.save
    assert o.save
    assert_not t.destroy
    assert o.destroy
    assert t.destroy
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

  test "should prevent event tag duplicates" do
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

  test "should interact with tags" do
    # Create organization and tag
    o = new_org
    t = new_tag
    assert o.save

    # Test successful tag assignment
    assert t.new_record?
    assert o.tags << t
    assert_not t.new_record?
    o = Org.find o.id
    assert o.tags.include?(t)

    # Test successful tag removal
    t = Org::Tag.find t.id
    t.orgs.clear
    assert o.tags.empty?
  end

  test "should prevent org tag duplicates" do
    # Create organization and tag
    o = new_org
    t = new_tag

    # Test adding tag first time
    o.tags << t
    assert o.save

    # Test adding tag second time
    assert_raises ActiveRecord::RecordNotUnique do
      o.tags << t
    end
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

  # Create user with defaults
  def new_user params={}
    User.new({
      display_id: 'TestUser',
      email: "testuser@example.com",
      password: 'TestPassw0rd',
      password_confirmation: 'TestPassw0rd'
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

  # Create organization tag with defaults
  def new_tag params={}
    Org::Tag.new({
      name: 'testtag',
      icon_url: "orgs/tags/testtag.png",
      color: 'ff80aa'
    }.merge(params))
  end

  # Deprecated "default_options" helper
  def default_options
    {
      type: org_types(:group),
      logo_url: "logos/image.png",
      cover_url: "covers/image.png",
      marker_url: "markers/image.png",
      marker_color: "000000",
      descriptions: [new_description]
    }
  end
end
