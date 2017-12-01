class Event::Description < ApplicationRecord
  ################
  # Associations #
  ################

  belongs_to :event, touch: true

  # Validate language presence and validity
  validates :language, inclusion: { in: I18n.available_locales.map(&:to_s) },
    uniqueness: { scope: :event }, presence: true

  # Validate content length and presence
  validates :content, length: { maximum: 5000 }, presence: true
end
