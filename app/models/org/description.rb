class Org::Description < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :org, touch: true

  ###############
  # Validations #
  ###############

  # Validate language presence and validity
  validates :language, inclusion: { in: I18n.available_locales.map(&:to_s) },
    uniqueness: { scope: :org }, presence: true

  # Validate content length and presence
  validates :content, length: { maximum: 5000 }, presence: true
end
