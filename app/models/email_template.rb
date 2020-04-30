class EmailTemplate < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: :competition_id, case_sensitive: true }, allow_nil: true, allow_blank: true

  validates :subject, liquid: true, allow_nil: true, allow_blank: true
  validates :content, liquid: true, allow_nil: true, allow_blank: true

  auto_strip_attributes :name, :subject
end
