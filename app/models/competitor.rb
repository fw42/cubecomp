class Competitor < ActiveRecord::Base
  include BelongsToCompetition

  validates :wca, uniqueness: { scope: :competition }, allow_nil: true, allow_blank: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :email, presence: true
  validates :email, email: true, allow_nil: true, allow_blank: true

  validates :birthday, inclusion: { in: (Date.new(1900)..(Time.now.utc - 1.years).to_date) }

  belongs_to :country
  validates :country, presence: true

  has_many :event_registrations, dependent: :destroy
  has_many :events, through: :event_registrations
end
