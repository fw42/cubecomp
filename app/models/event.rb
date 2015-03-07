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
  validates :name, presence: true

  validates :handle, presence: true, if: :for_registration?
  validates :handle, uniqueness: { scope: :competition_id }, allow_nil: true, allow_blank: true

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

  scope :for_competitors_table, ->{ where.not(state: 'not_for_registration') }

  def for_registration?
    state != 'not_for_registration'
  end

  def end_time
    return unless length_in_minutes
    start_time + length_in_minutes.minutes
  end
end
