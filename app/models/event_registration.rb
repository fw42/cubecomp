class EventRegistration < ActiveRecord::Base
  include BelongsToCompetition

  belongs_to :event
  validates :event, presence: true

  belongs_to :competitor
  validates :competitor, presence: true
  validates :competitor, uniqueness: { scope: :event }, allow_nil: true
end
