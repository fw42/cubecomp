module BelongsToCompetition
  extend ActiveSupport::Concern

  included do
    belongs_to :competition
    validates :competition, presence: true

    Competition.has_many self.table_name.to_sym, dependent: :destroy
  end
end
