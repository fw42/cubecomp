class PageBody < ActiveRecord::Base
  validates :content, presence: true
end
