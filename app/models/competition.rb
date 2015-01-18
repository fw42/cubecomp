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
  validate :validate_owner_has_permission

  belongs_to :default_locale, class_name: 'Locale', inverse_of: :competition, foreign_key: 'default_locale_id'
  validate :validate_default_locale_belongs_to_competition

  belongs_to :delegate, class_name: 'User', foreign_key: 'delegate_user_id'
  validate :validate_delegate_user_is_a_delegate

  has_many :news, dependent: :destroy
  has_many :competitors, dependent: :destroy
  has_many :days, inverse_of: :competition, dependent: :destroy
  has_many :day_registrations
  has_many :events, dependent: :destroy
  has_many :event_registrations
  has_many :locales, inverse_of: :competition, dependent: :destroy
  has_many :email_templates, dependent: :destroy
  has_many :permissions, dependent: :destroy
  has_many :users, through: :permissions
  has_many :theme_files, dependent: :destroy, autosave: true

  accepts_nested_attributes_for :locales, allow_destroy: true
  accepts_nested_attributes_for :days, allow_destroy: true

  validate :validate_has_at_least_one_locale
  validate :validate_has_at_least_one_day

  def default_locale
    super || locales.first
  end

  def default_locale_handle
    default_locale.handle
  end

  def default_locale_handle=(handle)
    self.default_locale = locales.detect{ |locale| locale.handle == handle }
  end

  def to_liquid
    @liquid_drop ||= CompetitionDrop.new(self)
  end

  private

  def validate_delegate_user_is_a_delegate
    return unless delegate
    return if delegate.delegate?
    errors.add(:delegate, 'does not have permission to be delegate of this competition')
  end

  def validate_owner_has_permission
    return unless owner
    return if owner.policy.login?(self)
    errors.add(:owner, 'does not have permission to be the owner of this competition')
  end

  def validate_has_at_least_one_locale
    return if locales.detect{ |locale| !locale.marked_for_destruction? }
    errors.add(:base, 'must have at least one language')
  end

  def validate_has_at_least_one_day
    return if days.detect{ |day| !day.marked_for_destruction? }
    errors.add(:base, 'must have at least one day')
  end

  def validate_default_locale_belongs_to_competition
    return if default_locale.nil? || default_locale.competition == self
    errors.add(:default_locale, 'must belong to this competition')
  end
end
