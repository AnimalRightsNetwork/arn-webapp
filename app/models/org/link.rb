class Org::Link < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :org, touch: true
  belongs_to :link_type

  ###############
  # Validations #
  ###############

  # Validate link type uniqueness per organization
  validates :link_type, uniqueness: { scope: :org }

  # Validate url presence
  validates :url, presence: true
end
