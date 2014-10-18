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

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_user_id'
  validate :owner_has_permission?

  belongs_to :delegate, class_name: 'User', foreign_key: 'delegate_user_id'
  validate :delegate_user_is_a_delegate?

  has_many :news, dependent: :destroy
  has_many :competitors, dependent: :destroy
  has_many :days, dependent: :destroy
  has_many :day_registrations
  has_many :events, dependent: :destroy
  has_many :event_registrations
  has_many :locales, dependent: :destroy
  has_many :theme_files, dependent: :destroy

  has_many :permissions, dependent: :destroy
  has_many :users, through: :permissions

  accepts_nested_attributes_for :locales, allow_destroy: true
  accepts_nested_attributes_for :days, allow_destroy: true

  def default_locale
    # TODO, store/fetch from cookie
    locales.first
  end

  def to_liquid
    @liquid_drop ||= CompetitionDrop.new(self)
  end

  private

  def delegate_user_is_a_delegate?
    return unless delegate
    return if delegate.delegate?
    errors.add(:delegate, 'does not have permission to be delegate of this competition')
  end

  def owner_has_permission?
    return unless owner
    return if owner.policy.login?(self)
    errors.add(:owner, 'does not have permission to be the owner of this competition')
  end
end
