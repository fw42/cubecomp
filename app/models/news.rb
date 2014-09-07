class News < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  validates :time, presence: true
# validates :locale, inclusion: ...
  validates :text, presence: true
end
