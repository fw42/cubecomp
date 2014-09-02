class Day < ActiveRecord::Base
  include BelongsToCompetition

  validates :date, presence: true
  validates :date, uniqueness: { scope: :competition }, allow_nil: true

  has_many :events, dependent: :destroy
end
