class Country < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: true }, allow_nil: true, allow_blank: true

  scope :ordered, ->{ order(name: :asc) }
end
