class EventRegistration < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  belongs_to :event
  validates :event, presence: true

  belongs_to :competitor
  validates :competitor, presence: true
  validates :competitor, uniqueness: { scope: :event }, allow_nil: true

  validate :competitor_registered_for_event_day?

  scope :on_day, ->(day){ joins(:event).where('events.day_id = ?', day) }

  private

  def competitor_registered_for_event_day?
    if competitor && event && !competitor.registered_on?(event.day_id)
      errors.add(:base, "competitor is not registered for the day of the event")
    end
  end
end
