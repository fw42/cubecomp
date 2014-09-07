class Permission < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  belongs_to :user
  validates :user, presence: true
  validates :user, uniqueness: { scope: :competition }, allow_nil: true
end
