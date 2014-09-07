class Day < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  validates :date, presence: true
  validates :date, uniqueness: { scope: :competition }, allow_nil: true

  has_many :events, dependent: :destroy
  has_many :registrations, class_name: 'DayRegistration', dependent: :destroy
  has_many :competitors, through: :registrations
end
