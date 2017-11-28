class Org < ApplicationRecord
  # Associations
  belongs_to :type
  has_many :events, validate: false

  # Validate organization id length and character restrictions
  validates :id, length: {minimum: 4, maximum: 30}, uniqueness: true,
    format: { with: /\A[a-z0-9]*\z/, error: :invalid_characters }, presence: true

  # Validate name
  validates :name, length: { minimum: 4, maximum: 30 }, uniqueness: true, presence: true
  
  # Validate url presence
  validates_presence_of :logo_url, :cover_url, :marker_url

  # Validate color format
  validates :marker_color, length: { is: 6 },
    format: { with: /\A[0-9a-f]*\z/, error: :invalid_characters }, presence: true

  # Make id only writable via display_id
  private :id=
  def display_id= display_id
    self.id = display_id&.downcase
    super(display_id)
  end
end
