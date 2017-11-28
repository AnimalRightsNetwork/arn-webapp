class Event::Type < ApplicationRecord
  # Associations
  has_many :events, foreign_key: :event_type_id, dependent: :restrict_with_error

  # Validate name uniqueness and presence
  validates :name, uniqueness: true, presence: true

  # Validate icon url presence
  validates :icon_url, presence: true
end
