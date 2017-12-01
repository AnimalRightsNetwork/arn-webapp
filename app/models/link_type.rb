class LinkType < ApplicationRecord
  ###############
  # Validations #
  ###############

  # Validate name uniqueness and presence
  validates :name, uniqueness: true, presence: true

  # Validate icon url presence
  validates :icon_url, presence: true
end
