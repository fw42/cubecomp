class Event < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  STATES = {
    'open_for_registration' => 'Open for registration',
    'open_with_waiting_list' => 'Waiting list',
    'registration_closed' => 'Closed (not open anymore)',
    'not_for_registration' => 'Not for registration'
  }

  belongs_to :day
  validates :day, presence: true

  has_many :registrations, class_name: 'EventRegistration', dependent: :destroy

  has_many :competitors, through: :registrations

  validates :name_short, presence: true

  validates :handle, presence: true, if: :for_registration?
  validates :handle,
    uniqueness: { scope: :competition_id },
    allow_nil: true, allow_blank: true,
    if: :for_registration?

  validates :start_time, presence: true
  validates :length_in_minutes, numericality: {
    only_integer: true,
    greater_than: 0
  }, allow_nil: true, allow_blank: true

  validates :max_number_of_registrations, numericality: {
    only_integer: true,
    greater_than: 0
  }, allow_nil: true, allow_blank: true

  validates :state, presence: true
  validates :state, inclusion: { in: Event::STATES.keys }, allow_nil: true, allow_blank: true

  auto_strip_attributes :name_short, :name, :handle, :timelimit, :format, :round, :proceed

  scope :for_competitors_table, ->{ where.not(state: 'not_for_registration') }

  scope :with_max_number_of_registrations, lambda {
    select('events.*, COUNT(DISTINCT(competitors.id)) AS number_of_confirmed_registrations')
      .where('max_number_of_registrations IS NOT NULL')
      .where('max_number_of_registrations >= 0')
      .joins(:competitors)
      .where('competitors.state' => 'confirmed')
      .joins(:day)
      .order('days.date ASC')
      .group('events.id')
  }

  validate :validate_cant_be_not_for_registration_if_registrations_exist

  def for_registration?
    state != 'not_for_registration'
  end

  def registrations?
    registrations.reject(&:marked_for_destruction?).size > 0
  end

  def end_time
    return unless length_in_minutes
    start_time + length_in_minutes.minutes
  end

  private

  def validate_cant_be_not_for_registration_if_registrations_exist
    return if for_registration?
    return unless registrations?
    errors.add(:state, "state can't be \"#{STATES['not_for_registration']}\" if event already has registrations")
  end
end
