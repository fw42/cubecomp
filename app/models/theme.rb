class Theme < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true, allow_nil: true, allow_blank: true

  has_many :files, class_name: 'ThemeFile', dependent: :destroy
end
