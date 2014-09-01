class User < ActiveRecord::Base
  validates :email, presence: true, email: true
  validates :email, uniqueness: true, allow_nil: true, allow_blank: true

  has_many :competitions, through: :permissions
end
