class Permission < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  belongs_to :user
  validates :user, presence: true, uniqueness: { scope: :competition }
end
