# Instantiation shortcuts for each data model
module ModelInstantiationHelper
  # Create user with defaults
  def new_user opts={}
    User.new({
      display_id: "TestUser",
      email: "testuser@example.com",
      password: "TestPassw0rd",
      password_confirmation: "TestPassw0rd"
    }.merge(opts))
  end

  # Create organization with defaults
  def new_org opts={}
    Org.new({
      display_id: "TestOrg",
      type: new_org_type,
      name: "Test Organization",
      logo_url: "orgs/logos/testorg.png",
      cover_url: "orgs/covers/testorg.png",
      marker_url: "orgs/markers/testorg.png",
      marker_color: "00ff00",
      descriptions: [new_org_description]
    }.merge(opts))
  end

  # Create organization type with defaults
  def new_org_type opts={}
    Org::Type.new({
      name: "testtype",
      icon_url: "orgs/types/testtype.png"
    }.merge(opts))
  end

  # Create organization description with defaults
  def new_org_description opts={}
    Org::Description.new({
      # Needs to get assigned to an organization
      language: I18n.locale,
      content: "Amet earum expedita consectetur ducimus id."
    }.merge(opts))
  end

  # Create organization tag with defaults
  def new_org_tag opts={}
    Org::Tag.new({
      name: "testtag",
      icon_url: "orgs/tags/testtag",
      color: "00ff00"
    }.merge(opts))
  end

  # Create organization link with defaults
  def new_org_link opts={}
    Org::Link.new({
      # Needs to get assigned to an organization
      link_type: new_link_type,
      url: "https://example.com/"
    }.merge(opts))
  end

  # Create link type with defaults
  def new_link_type opts={}
    LinkType.new({
      name: "testtype",
      icon_url: "link_types/testtype.png"
    }.merge(opts))
  end

  # Create event with defaults
  def new_event opts={}
    Event.new({
      type: new_event_type,
      name: "testevent",
      start_time: DateTime.now,
      descriptions: [new_event_description]
    }.merge(opts))
  end

  # Create event type with defaults
  def new_event_type opts={}
    Event::Type.new({
      name: "testtype",
      icon_url: "events/types/testtype.png"
    }.merge(opts))
  end

  # Create event description with defaults
  def new_event_description opts={}
    Event::Description.new({
      # Needs to be assigned to an event
      language: I18n.locale,
      content: "Sit modi veritatis aspernatur assumenda itaque."
    }.merge(opts))
  end

  # Create event tag with defaults
  def new_event_tag opts={}
    Event::Tag.new({
      name: "testtag",
      icon_url: "events/tags/testtag.png",
      color: "00ff00"
    }.merge(opts))
  end
end
