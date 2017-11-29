class LinkType < ApplicationRecord
  # Association
  #has_and_belongs_to_many :orgs

  # Validate name uniqueness and presence
  validates :name, uniqueness: true, presence: true

  # Validate icon url presence
  validates :icon_url, presence: true
end
