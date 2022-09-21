# frozen_string_literal: true

class Club < ApplicationRecord
  has_many :patrols
  has_many :notices
  has_many :outreach_patrols
  has_many :proficiencies
  has_many :patrol_members, through: :patrols
  has_many :users, through: :patrol_members
  has_many :awards, through: :users
  has_many :rosters, through: :patrols
  has_many :requests, through: :rosters

  scope :with_show_patrols, -> { where(is_active: true, show_patrols: true) }
end
