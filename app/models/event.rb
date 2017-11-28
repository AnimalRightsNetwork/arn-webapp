class Event < ApplicationRecord
  # Associations
  belongs_to :org, optional: true
  belongs_to :type
  has_many :descriptions, autosave: true, dependent: :destroy

  # Validate event name
  validates :name, length: {minimum: 4, maximum: 64}, presence: true

  # Validate description
  validate :descriptions_not_empty

  # Validate start time
  validates :start_time, presence: true

  # Validate image url
  validates :image_url, presence: true, allow_nil: true

  # Helper methods
  private
  def descriptions_not_empty
    errors.add(:descriptions, :empty) if descriptions.empty?
  end
end
