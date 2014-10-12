class EventRegistration < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  belongs_to :event
  validates :event, presence: true

  belongs_to :competitor
  validates :competitor, presence: true
  validates :competitor_id, uniqueness: { scope: :event_id }, allow_nil: true

  validate :competitor_registered_for_event_day?
  validate :competition_ids_match

  scope :on_day, ->(day){ joins(:event).where('events.day_id = ?', day) }

  validate :event_for_registration?

  private

  def competitor_registered_for_event_day?
    return unless competitor && event
    return if competitor.registered_on?(event.day_id)
    errors.add(:base, 'competitor is not registered for the day of the event')
  end

  def event_for_registration?
    return unless event
    return if event.state != 'not_for_registration'
    errors.add(:event, 'is not for registration')
  end

  def competition_ids_match
    return unless competition_id

    if event && competition_id != event.competition_id
      errors.add(:competition_id, 'does not match event competition_id')
    end

    if competitor && competition_id != competitor.competition_id
      errors.add(:competition_id, 'does not match competitor competition_id')
    end

    true
  end
end
