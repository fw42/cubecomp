class Theme < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true, allow_nil: true, allow_blank: true

  has_many :file_templates, class_name: 'ThemeFileTemplate', dependent: :destroy
end
