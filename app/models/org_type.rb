class OrgType < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :icon_url, presence: true
end
