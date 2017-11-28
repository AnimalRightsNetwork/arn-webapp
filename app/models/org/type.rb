class Org::Type < ApplicationRecord
  # Association
  has_many :orgs, dependent: :restrict_with_error

  # Validate name uniqueness and presence
  validates :name, uniqueness: true, presence: true

  # Validate icon url presence
  validates :icon_url, presence: true
end
