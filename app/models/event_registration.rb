class EventRegistration < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  belongs_to :event
  validates :event, presence: true

  belongs_to :competitor
  validates :competitor, presence: true
  validates :competitor, uniqueness: { scope: :event }, allow_nil: true
end
