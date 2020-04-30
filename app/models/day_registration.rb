class DayRegistration < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  belongs_to :day
  validates :day, presence: true

  belongs_to :competitor
  validates :competitor, presence: true
  validates :competitor_id, uniqueness: { scope: :day_id, case_sensitive: true }, allow_nil: true, allow_blank: true

  validate :validate_competition_ids_match

  after_destroy :destroy_event_registrations

  private

  def destroy_event_registrations
    competitor.event_registrations.on_day(day).each(&:destroy)
  end

  def validate_competition_ids_match
    return unless competition_id

    if day && competition_id != day.competition_id
      errors.add(:competition_id, 'does not match day competition_id')
    end

    if competitor && competition_id != competitor.competition_id
      errors.add(:competition_id, 'does not match competitor competition_id')
    end

    true
  end
end
