class Org < ApplicationRecord
  ######################
  # Attribute handling #
  ######################

  # Make id only writable via display_id
  private :id=
  def display_id= display_id
    self.id = display_id&.downcase
    super(display_id)
  end

  ################
  # Associations #
  ################

  belongs_to :type, foreign_key: :org_type_id
  has_and_belongs_to_many :tags, association_foreign_key: :org_tag_id
  has_many :descriptions, autosave: true, dependent: :destroy
  has_many :links, autosave: true, dependent: :destroy
  has_many :events
  has_and_belongs_to_many :admins, class_name: :User, join_table: :org_administrations

  ###############
  # Validations #
  ###############

  # Validate organization id length and character restrictions
  validates :id, length: {minimum: 4, maximum: 32}, uniqueness: true,
    format: { with: /\A[a-z0-9]*\z/, error: :invalid_characters }, presence: true

  # Validate name length, uniqueness and presence
  validates :name, length: { minimum: 4, maximum: 48 }, uniqueness: true, presence: true
  
  # Validate existence of a description
  validate :descriptions_not_empty

  # Validate url presence
  validates_presence_of :logo_url, :cover_url, :marker_url

  # Validate video url
  validates :video_url, presence: true, allow_nil: true

  # Validate color format
  validates :marker_color, length: { is: 6 },
    format: { with: /\A[0-9a-f]*\z/, error: :invalid_characters }, presence: true

  ###########
  # Helpers #
  ###########
  private
    # Require at least one description
    def descriptions_not_empty
      errors.add(:descriptions, :empty) if descriptions.empty?
    end
end
