require 'test_helper'

class Org::DescriptionTest < ActiveSupport::TestCase
  include ModelInstantiationHelper

  test "should only save with available language" do
    # Test description without language
    d = new_org_description language: nil
    o = new_org descriptions: [d]
    assert_invalid o

    # Test invalid language
    d.language = :gazorpazorp
    assert_invalid o

    # Test valid language
    d.language = I18n.locale
    assert o.save
  end

  test "should only save with valid content" do
    # Test without content
    d = new_org_description content: nil
    o = new_org descriptions: [d]
    assert_invalid o

    # Test with empty content
    d.content = ""
    assert_invalid o

    # Test with too long content
    d.content = "Hello" * 1000 + "."
    assert_invalid o

    # Test upper limit
    d.content = "Hello" * 1000
    assert o.save

    # Test lower limit
    d.content = "H"
    assert o.save
  end

  test "should enforce uniqueness of language per organization" do
    # Create descriptions and organizations
    l1 = I18n.available_locales[0]
    l2 = I18n.available_locales[1]
    d1 = new_org_description language: l1, content: "Test"
    d2 = new_org_description language: l1, content: "Test"
    o1 = new_org display_id: "Org1", name: "Organization 1", descriptions: []
    o2 = new_org display_id: "Org2", name: "Organization 2", descriptions: []

    # Test same language and same organization
    o1.descriptions << d1
    assert o1.save
    o1.descriptions << d2
    assert_invalid o1

    # Test different languages and same organization
    d2.language = l2
    assert o1.save
  end

  test "should change updated_at timestamp on organization model" do
    # Create organization and description
    d = new_org_description
    o = new_org descriptions: [d]

    # Save organization
    assert o.save

    # Test updated_at change when changing description
    assert_changes 'o.updated_at' do
      d.content = "Some other content"
      d.save
    end
  end
end
