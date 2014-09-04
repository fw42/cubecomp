class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :email, presence: true
  validates :email, email: true, allow_nil: true, allow_blank: true
  validates :email, uniqueness: true, allow_nil: true, allow_blank: true

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :permissions, dependent: :destroy
  has_many :competitions, through: :permissions

  def name
    "#{first_name} #{last_name}"
  end
end
