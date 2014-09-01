class Competition < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :handle, presence: true, uniqueness: true
  validates :staff_email, presence: true
  validates :city_name, presence: true

  belongs_to :country
  validates :country, presence: true

  belongs_to :default_registration_country, class_name: 'Country'
  validates :default_registration_country, presence: true
end
