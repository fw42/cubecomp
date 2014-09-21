class Competitor < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  validates :wca, uniqueness: { scope: :competition_id }, allow_nil: true, allow_blank: true
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

  validate :registered_for_at_least_one_day?
  validate :male_not_nil?

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

  private

  def registered_for_at_least_one_day?
    ### TODO: add test, make nested_attributes work for days, etc.
    # if day_registrations.count == 0
    #   errors.add(:base, 'must register for at least one competition day')
    # end
  end

  def male_not_nil?
    if male.nil?
      errors.add(:male, 'must be either true or false')
    end
  end
end
