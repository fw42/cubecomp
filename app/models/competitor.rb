class Competitor < ActiveRecord::Base
  STATES = %w(new confirmed disabled)

  belongs_to :competition
  validates :competition, presence: true

  validates :wca, uniqueness: { scope: :competition_id }, allow_nil: true, allow_blank: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :email, presence: true
  validates :email, email: true, allow_nil: true, allow_blank: true

  def self.valid_birthday_range
    Date.new(1900)..(Time.now.utc - 1.years).to_date
  end
  validates :birthday, inclusion: { in: Competitor.valid_birthday_range }

  validates :state, presence: true
  validates :state, inclusion: { in: STATES }, allow_nil: true, allow_blank: true

  belongs_to :country
  validates :country, presence: true

  has_many :event_registrations, dependent: :destroy
  has_many :events, through: :event_registrations

  has_many :day_registrations, dependent: :destroy
  has_many :days, through: :day_registrations

  before_validation :set_default_state
  validate :male_not_nil?

  scope :confirmed, ->{ where(state: 'confirmed') }

  scope :for_nametags, lambda {
    confirmed
      .includes(:country)
      .order(:last_name, :first_name)
  }

  def name
    [first_name, last_name].join(' ')
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

  def age
    today = Time.now.to_date
    age = today.year - birthday.year

    unless (today.month > birthday.month) || (today.month == birthday.month && today.day >= birthday.day)
      age -= 1
    end

    age
  end

  def event_registration_status(event)
    registration = event_registrations.where(event: event).first

    if registration.nil?
      'not_registered'
    elsif registration.waiting
      'waiting'
    else
      'registered'
    end
  end

  def registration_service
    @registration_service ||= RegistrationService.new(self)
  end

  private

  def set_default_state
    self.state ||= STATES.first
  end

  def male_not_nil?
    return unless male.nil?
    errors.add(:male, 'must be either true or false')
  end
end
