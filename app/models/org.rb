class Org < ApplicationRecord
  belongs_to :type

  # Validate organization id length and character restrictions
  validates :id, length: {minimum: 4, maximum: 30}, uniqueness: true,
    format: { with: /\A[a-z0-9]*\z/, message: :invalid_characters }, presence: true

  # Validate display id
  validates :display_id, presence: true
  validate :display_id_equality

  # Validate name
  validates :name, length: { minimum: 4, maximum: 30 }, uniqueness: true, presence: true
  
  # Validate url presence
  validates_presence_of :logo_url, :cover_url, :marker_url

  # Validate color format
  validates :marker_color, length: { is: 6 },
    format: { with: /\A[0-9a-f]*\z/, message: :invalid_characters }, presence: true

  # Helper methods
  private
    def display_id_equality
      unless display_id&.downcase == id
        errors.add(:display_id, :incompatible_with_id)
      end
    end
end
