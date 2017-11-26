class Org::Type < ApplicationRecord
  has_many :orgs, dependent: :restrict_with_error

  validates :name, uniqueness: true, presence: true
  validates :icon_url, presence: true
end
