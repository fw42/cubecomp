class Event < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  STATES = [
    'open_for_registration',
    'open_with_waiting_list',
    'registration_closed',
    'not_for_registration'
  ]

  belongs_to :day
  validates :day, presence: true

  has_many :registrations, class_name: 'EventRegistration', dependent: :destroy
  has_many :competitors, through: :registrations

  validates :name_short, presence: true
  validates :name, presence: true

  validates :handle, presence: true, unless: ->(event) { event.state == 'not_for_registration' }
  validates :handle, uniqueness: { scope: :competition }, allow_nil: true, allow_blank: true

  validates :start_time, presence: true
  validates :length_in_minutes, numericality: {
    only_integer: true,
    greater_than: 0
  }, allow_nil: true

  validates :max_number_of_registrations, numericality: {
    only_integer: true,
    greater_than: 0
  }, allow_nil: true

  validates :state, presence: true
  validates :state, inclusion: { in: Event::STATES }
end
