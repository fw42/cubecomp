class DayRegistration < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  belongs_to :day
  validates :day, presence: true

  belongs_to :competitor
  validates :competitor, presence: true
  validates :competitor_id, uniqueness: { scope: :day_id }, allow_nil: true, allow_blank: true

  after_destroy :destroy_event_registrations

  private

  def destroy_event_registrations
    competitor.event_registrations.on_day(day).each(&:destroy)
  end
end
