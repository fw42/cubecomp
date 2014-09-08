class Competitor < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

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

  has_many :day_registrations, dependent: :destroy
  has_many :days, through: :day_registrations

  # TODO: validate that user is registered for at least one day

  def name
    [first_name, last_name].join(" ")
  end

  def registered_on?(day)
    day_registrations.where(day: day).exists?
  end

  def competing_on?(day)
    events.where(day: day).exists?
  end

  def guest_on?(day)
    registered_on?(day) && !competing_on?(day)
  end
end
