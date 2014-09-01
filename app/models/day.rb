class Day < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  validates :date, presence: true

  has_many :events
end
