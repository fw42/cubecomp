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
  validate :validate_male_not_nil

  auto_strip_attributes :first_name, :last_name, :wca, :email

  before_validation do
    self.wca = wca.upcase if wca
  end

  scope :confirmed, ->{ where(state: 'confirmed') }

  def name
    [first_name, last_name].join(' ')
  end

  def registered_on?(day_id)
    day_id = day_id.id if day_id.is_a?(Day)
    day_registrations.select{ |registration| registration.day_id == day_id }.size > 0
  end

  def competing_on?(day_id)
    day_id = day_id.id if day_id.is_a?(Day)
    events.select{ |event| event.day_id == day_id }.size > 0
  end

  def guest_on?(day)
    registered_on?(day) && !competing_on?(day)
  end

  def event_registrations_by_day(include_waiting = false)
    rel = event_registrations
    rel = rel.where(waiting: false) unless include_waiting

    grouped = {}
    competition.days.each do |day|
      grouped[day] = rel.select{ |registration| registration.event.day == day }
    end
    grouped
  end

  def event_registration_counts(include_waiting = false)
    grouped = event_registrations_by_day(include_waiting)
    grouped.to_a.sort_by{ |day, _| day }.map{ |_, registrations| registrations.count }
  end

  def age
    today = Time.now.to_date
    age = today.year - birthday.year

    unless (today.month > birthday.month) || (today.month == birthday.month && today.day >= birthday.day)
      age -= 1
    end

    age
  end

  def birthday_on?(date)
    birthday.month == date.month && birthday.day == date.day
  end

  def birthday_on_competition?
    competition.days.any?{ |day| birthday_on?(day.date) }
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

  def checklist_service
    @checklist_service ||= ChecklistService.new(self)
  end

  def to_liquid
    @liquid_drop ||= CompetitorDrop.new(self)
  end

  private

  def set_default_state
    self.state ||= STATES.first
  end

  def validate_male_not_nil
    return unless male.nil?
    errors.add(:male, 'must be either true or false')
  end
end
