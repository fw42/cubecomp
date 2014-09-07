class DayRegistration < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  belongs_to :day
  validates :day, presence: true

  belongs_to :competitor
  validates :competitor, presence: true
  validates :competitor, uniqueness: { scope: :day }, allow_nil: true, allow_blank: true
end
