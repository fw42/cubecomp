class Page < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true, if: :competition_id

  validates :handle, presence: true
  validates :handle, uniqueness: { scope: :competition }, allow_nil: true, allow_blank: true

  belongs_to :template_body, class_name: 'PageTemplateBody', foreign_key: 'page_template_body_id'
  validates :template_body, presence: true

  delegate :content, to: :template_body

  scope :default_templates, ->{ where(competition: nil) }
end
