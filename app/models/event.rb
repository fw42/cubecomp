class Event < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  STATES = {
    'open_for_registration' => 'Open for registration',
    'open_with_waiting_list' => 'Waiting list',
    'registration_closed' => 'Closed (not open anymore)',
    'not_for_registration' => 'Not for registration'
  }.freeze

  belongs_to :day
  validates :day, presence: true

  has_many :registrations, class_name: 'EventRegistration', dependent: :destroy

  has_many :competitors, through: :registrations

  validates :name, presence: true

  validates :handle, presence: true, if: :for_registration?
  validates :handle,
    uniqueness: {
      scope: :competition_id,
      message: lambda do |_, e|
        "#{e[:value]} has already been used by another event of this competition that is also for registration"
      end
    },
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

  auto_strip_attributes :name, :handle, :timelimit, :format, :round, :proceed

  scope :for_competitors_table, ->{ where.not(state: 'not_for_registration') }
  scope :wca, ->{ where(handle: WCA_EVENTS.map{ |event| [ event[:handle], event[:wca_handle] ] }.flatten.compact.uniq) }

  scope :for_registration, ->{ where.not(state: 'not_for_registration') }

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

  def wca_handle
    return unless wca_handle_index
    WCA_EVENTS[wca_handle_index][:wca_handle]
  end

  def wca_handle_index
    @wca_handle_index ||= begin
      index = WCA_EVENTS.find_index{ |wca_event| handle == wca_event[:handle] }
      index ||= WCA_EVENTS.find_index{ |wca_event| handle == wca_event[:wca_handle] }
      index
    end
  end

  def registrations?
    !registrations.reject(&:marked_for_destruction?).empty?
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
