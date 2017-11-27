class Event::Type < ApplicationRecord
  # Validate attribute presence
  validates_presence_of :name, :icon_url
end
