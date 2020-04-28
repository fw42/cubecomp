class Day < ActiveRecord::Base
  include EntranceFeeValidation

  belongs_to :competition, inverse_of: :days
  validates :competition, presence: true

  validates :date, presence: true
  validates :date, uniqueness: { scope: :competition_id, case_sensitive: true }, allow_nil: true

  has_many :events, dependent: :destroy, autosave: true
  has_many :registrations, class_name: 'DayRegistration', dependent: :destroy
  has_many :competitors, through: :registrations

  scope :with_events, ->{ joins(:events).select('DISTINCT(days.id), days.*') }
end
