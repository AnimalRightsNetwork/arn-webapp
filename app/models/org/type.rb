class Org::Type < ApplicationRecord
  ################
  # Associations #
  ################

  has_many :orgs, foreign_key: :org_type_id, dependent: :restrict_with_error

  ###############
  # Validations #
  ###############

  # Validate name uniqueness and presence
  validates :name, uniqueness: true, presence: true

  # Validate icon url presence
  validates :icon_url, presence: true
end
