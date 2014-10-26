class EmailTemplate < ActiveRecord::Base
  include LiquidContent

  belongs_to :competition
  validates :competition, presence: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: :competition_id }, allow_nil: true, allow_blank: true
end
