class News < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  validates :time, presence: true
  validates :text, presence: true

  belongs_to :locale
  validates :locale, presence: true
end
