class Permission < ActiveRecord::Base
  include BelongsToCompetition

  belongs_to :user
  validates :user, presence: true
  validates :user, uniqueness: { scope: :competition }, allow_nil: true
end
