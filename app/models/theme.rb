class Theme < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: true }, allow_nil: true, allow_blank: true

  auto_strip_attributes :name

  has_many :files, class_name: 'ThemeFile', dependent: :destroy, autosave: true
end
