class Event < ApplicationRecord
  # Associations
  belongs_to :org, optional: true
  belongs_to :type, foreign_key: :event_type_id
  has_many :descriptions, autosave: true, dependent: :destroy
  has_and_belongs_to_many :tags, association_foreign_key: :event_tag_id

  # Validate event name
  validates :name, length: {minimum: 4, maximum: 64}, presence: true

  # Validate description
  validate :descriptions_not_empty

  # Validate start time
  validates :start_time, presence: true

  # Validate image url
  validates :image_url, presence: true, allow_nil: true

  # Validate presence of facebook url
  validates :fb_url, presence: true, allow_nil: true

  # Helper methods
  private
  def descriptions_not_empty
    errors.add(:descriptions, :empty) if descriptions.empty?
  end
end
