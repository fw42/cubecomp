class Permission < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  belongs_to :user, inverse_of: :permissions
  validates :user, presence: true
  validates :user_id, uniqueness: { scope: :competition_id, case_sensitive: true }, allow_nil: true
end
