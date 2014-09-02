module BelongsToCompetition
  extend ActiveSupport::Concern

  included do
    belongs_to :competition
    validates :competition, presence: true
  end
end
