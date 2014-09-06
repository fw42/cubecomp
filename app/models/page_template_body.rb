class PageTemplateBody < ActiveRecord::Base
  validates :content, presence: true
end
