class Event < ActiveRecord::Base
  STATES = [
    :open_for_registration,
    :open_with_waiting_list,
    :registration_closed,
    :not_for_registration
  ]

  belongs_to :competition
  validates :competition, presence: true

  belongs_to :day
  validates :day, presence: true

  has_many :event_registrations, dependent: :destroy
  has_many :competitors, through: :event_registrations

  validates :name_short, presence: true
  validates :name_long, presence: true
  validates :handle, presence: true, unless: ->(event) { event.state == :not_for_registration }
  validates :handle, uniquenes: true, allow_nil: true, allow_blank: true

  validates :start_time, presence: true
  validates :max_number_of_registrations, numericality: {
    only_integer: true,
    greater_than: 0
  }, allow_nil: true, allow_blank: true

  validates :state, inclusion: { in: Event::STATES }
end
