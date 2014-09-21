class ThemeFile < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  validates :filename, presence: true
  validates :filename, uniqueness: { scope: :competition }, allow_nil: true, allow_blank: true
end