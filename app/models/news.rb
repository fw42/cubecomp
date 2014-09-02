class News < ActiveRecord::Base
  include BelongsToCompetition

  validates :time, presence: true
# validates :locale, inclusion: ...
  validates :text, presence: true
end
