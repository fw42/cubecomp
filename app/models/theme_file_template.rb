class ThemeFileTemplate < ActiveRecord::Base
  belongs_to :theme
  validates :theme, presence: true

  validates :filename, presence: true
  validates :filename, uniqueness: { scope: :theme_id }, allow_nil: true, allow_blank: true
end
