class Page < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  validates :handle, presence: true
  validates :handle, uniqueness: { scope: :competition }, allow_nil: true, allow_blank: true

  validates :locale, presence: true

  belongs_to :body, class_name: 'PageBody', foreign_key: 'page_body_id'
  validates :body, presence: true

  delegate :content, to: :body
end
