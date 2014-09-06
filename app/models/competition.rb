class Competition < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true, allow_nil: true, allow_blank: true

  validates :handle, presence: true
  validates :handle, uniqueness: true, allow_nil: true, allow_blank: true

  validates :staff_email, presence: true
  validates :staff_email, email: true, allow_nil: true, allow_blank: true

  validates :city_name, presence: true

  belongs_to :country
  validates :country, presence: true

  belongs_to :delegate, class_name: 'User', foreign_key: 'delegate_user_id'

  has_many :news, dependent: :destroy
  has_many :competitors, dependent: :destroy
  has_many :days, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :event_registrations, dependent: :destroy
  has_many :locales, dependent: :destroy
  has_many :theme_files, dependent: :destroy

  has_many :permissions, dependent: :destroy
  has_many :users, through: :permissions
end
