class Locale < ActiveRecord::Base
  ALL = {
    'de' => 'Deutsch',
    'en' => 'English'
  }

  belongs_to :competition, inverse_of: :locales
  validates :competition, presence: true

  validates :handle, presence: true
  validates :handle, uniqueness: { scope: :competition_id }, allow_nil: true, allow_blank: true
  validates :handle, inclusion: { in: ALL }, allow_nil: true, allow_blank: true

  has_many :news, dependent: :destroy

  has_one :competition_with_default,
    class_name: 'Competition',
    foreign_key: 'default_locale_id',
    inverse_of: :default_locale,
    dependent: :nullify

  def name
    Locale::ALL[handle]
  end
end
