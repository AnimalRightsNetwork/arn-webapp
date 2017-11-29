class Org::Link < ApplicationRecord
  # Associations
  belongs_to :org, touch: true
  belongs_to :link_type

  # Validate url presence
  validates :url, presence: true

  # Validate link type uniqueness per organization
  validates :link_type, uniqueness: { scope: :org_id }
end
