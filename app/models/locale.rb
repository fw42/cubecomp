class Locale < ActiveRecord::Base
  ALL = {
    'de' => 'Deutsch',
    'en' => 'English'
  }

  belongs_to :competition
  validates :competition, presence: true

  validates :handle, presence: true
  validates :handle, uniqueness: { scope: :competition }, allow_nil: true, allow_blank: true
  validates :handle, inclusion: { in: ALL }, allow_nil: true, allow_blank: true

  has_many :news, dependent: :destroy

  def name
    Locale::ALL[handle]
  end
end
