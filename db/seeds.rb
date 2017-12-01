# Clear database
[User, Event, Org, Event::Type, Event::Tag, Org::Type, Org::Tag, LinkType, Org::Link].each do |c|
  c.destroy_all
end

# Create users
User.create([
  {
    display_id: 'Alice',
    email: "alice@example.com",
    password: "AlicePassw0rd",
    password_confirmation: "AlicePassw0rd"
  },
  {
    display_id: 'Bob',
    email: "bob@example.com",
    password: "BobPassw0rd",
    password_confirmation: "BobPassw0rd",
    admin: true
  }
])

# Create link types
LinkType.create([
  {
    name: 'website',
    icon_url: "link_types/website.png"
  },
  {
    name: 'facebook',
    icon_url: "link_types/facebook.png"
  }
])

# Create organizations types
Org::Type.create([
  {
    name: 'association',
    icon_url: "orgs/types/association.png"
  },
  {
    name: 'group',
    icon_url: "orgs/types/group.png"
  }
])

# Create organizations tags
Org::Tag.create([
  {
    name: 'voluntary',
    icon_url: "orgs/tags/voluntary.png",
    color: "00ff00"
  },
  {
    name: 'research',
    icon_url: "orgs/tags/research.png",
    color: "ffff00"
  }
])

# Create organizations
Org.create([
  {
    display_id: 'AVBerlin',
    type: Org::Type.find_by(name: 'group'),
    name: "Anonymous for the Voiceless Berlin",
    logo_url: "orgs/logos/avberlin.png",
    cover_url: "orgs/covers/avberlin.jpg",
    video_url: "orgs/videos/avberlin.mp4",
    marker_url: "orgs/markers/avberlin.png",
    marker_color: "000000",
    tags: [ Org::Tag.find_by(name: 'voluntary') ],
    links: [
      Org::Link.new(
        link_type: LinkType.find_by(name: 'facebook'),
        url: "https://www.facebook.com/groups/145636199303931/"
      )
    ],
    descriptions: [
      Org::Description.new(
        language: :en,
        content: 'Anonymous for the Voiceless shows video footage from facory farms and slaughter houses in the streets and reaches out to interested passers-by to inform them about veganism.\n\nA team of "cubers" stands in a cube formation with masks and laptops, showing the footage while a team of "outreachers" starts conversations with interested pedestrians.'
      ),
      Org::Description.new(
        language: :de,
        content: 'Anonymous for the Voiceless zeigt Videoaufnahmen aus Tierhaltungsanlagen und Schlachthäusern auf der Straße und Spricht mit interessierten Passanten um sie über Veganismus zu infromieren.\n\nEin Team von "Cubern" steht mit Masken und Laptops in einer recheckigen Formation um die Aufnahmen zu zeigen, während ein Team von "Outreachern" Konversationen mit interessierten Passanten führt.'
      )
    ],
    admins: [ User.find('alice') ]
  },
  {
    display_id: 'Tierschutzbuero',
    type: Org::Type.find_by(name: 'association'),
    name: "Deutsches Tierschutzbuero",
    logo_url: "orgs/logos/tierschutzbuero.png",
    cover_url: "orgs/covers/tierschutzbuero.jpg",
    marker_url: "orgs/markers/tierschutzbuero.png",
    marker_color: "026eb6",
    tags: [ Org::Tag.find_by(name: 'research') ],
    links: [
      Org::Link.new(
        link_type: LinkType.find_by(name: 'website'),
        url: "https://www.tierschutzbuero.de/"
      ),
      Org::Link.new(
        link_type: LinkType.find_by(name: 'facebook'),
        url: "https://www.facebook.com/Tierschutzbuero"
      )
    ],
    descriptions: [
      Org::Description.new(
        language: :de,
        content: 'Das Deutsche Tierschutzbüro e.V. verbindet die praktische Tierschutzarbeit mit moderner Öffentlichkeitsarbeit, um so nicht nur dem einzelnen Tier zu helfen, sondern auch an einem gesellschaftlichen Bewusstseinswandel mitzuwirken. Immer wieder gelingt es dem Deutschen Tierschutzbüro so, systemimmanente Tierhaltungsmissstände, vor allem in der industriellen Nutztierhaltung, aufzudecken und bundesweit publik zu machen.'
      )
    ]
  }
])

# Create event types
Event::Type.create([
  {
    name: 'demonstration',
    icon_url: "events/types/demonstration.png"
  },
  {
    name: 'outreach',
    icon_url: "events/types/outreach.png"
  }
])

# Create event tags
Event::Tag.create([
  {
    name: 'graphic',
    icon_url: "events/tags/graphic.png",
    color: "aa0000"
  },
  {
    name: 'disobedience',
    icon_url: "events/tags/disobedience.png",
    color: "ffff00"
  },
  {
    name: 'non_ar',
    icon_url: "events/tags/non_ar.png",
    color: "ff0000"
  }
])

# Create events
Event.create([
  {
    org: Org.find('avberlin'),
    type: Event::Type.find_by(name: 'outreach'),
    name: "Cube of Truth (Alexanderplatz)",
    image_url: "events/images/0.png",
    lat: 52.52228,
    lon: 13.41271,
    start_time: DateTime.new(2017, 12, 7, 18, 0, 0),
    end_time: DateTime.new(2017, 12, 7, 21, 0, 0),
    fb_url: "https://www.facebook.com/events/146170619351524/",
    tags: [ Event::Tag.find_by(name: 'graphic') ],
    descriptions: [
      Event::Description.new(
        language: :de,
        content: "'Cube of Truth'-Straßenaktivismus und Öffentlichkeitsarbeit: Wir bringen die Realität hinter Tierprodukten an die Konsumenten, um über die Gewalt in der Fleisch, Eier- und Milchindustrie aufzuklären. Zudem bieten wir die Möglichkeit das Leben der 'Nutztiere', mithilfe von Virtual-Reality-Brillen, aus deren Perspektive nachzuempfinden. Alle Aufnahmen zeigen die Standardmethoden in der Deutschen und internationalen Tierproduktion.\n\bWICHTIG: Bitte bringe einen Laptop oder ein Tablet mit, wenn du eines hast. Wenn nicht, komm gerne auch vorbei. Masken und Schilder werden dir zur Verfügung gestellt. Bitte trage schwarze Kleidung. Hierbei wäre ein schwarzer Pullover optimal. Stelle sicher, dass dein Laptop/Tablet voll geladen ist."
      ),
      Event::Description.new(
        language: :en,
        content: "Direct action street outreach and demonstration. We provide information for people in an attempt to break down unawareness and show the cruelty inherent in meat, dairy and egg production. We will also be offering public the opportunity to experience life from a livestock animal's perspective with virtual reality technology. All footage used shows the standard practices for animal-based food production in Germany.\n\nIMPORTANT: Please bring a laptop or tablet if you have one. If you do not, please come along anyway; masks and signs will be provided on the day. Please wear black clothing if possible and a black hood is best.Please fully charge your laptop/tablet for the day."
      )
    ]
  },
  {
    type: Event::Type.find_by(name: 'demonstration'),
    name: "Wir haben es Satt",
    image_url: "events/images/1.png",
    start_time: DateTime.new(2018, 1, 20, 11, 0, 0),
    tags: [ Event::Tag.find_by(name: 'non_ar') ],
    descriptions: [
      Event::Description.new(
        language: :de,
        content: "Demo für bäuerliche, ökologische Landwirtschaft.\n\nDie Demo ist nicht Tierrechtsbezogen, bietet aber die Möglichkeit für Tierrechte und Veganismus zu werben."
      )
    ]
  }
])

