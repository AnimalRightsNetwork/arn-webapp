class Event::Tag < ApplicationRecord
  # Associations

  # Validate uniqueness and presence of name
  validates :name, uniqueness: true, presence: true

  # Validate presence of icon url
  validates :icon_url, presence: true

  # Validate length, format and presence of color
  validates :color, length: { is: 6 },
    format: { with: /\A[0-9a-f]*\z/, error: :invalid_characters }, presence: true
end
