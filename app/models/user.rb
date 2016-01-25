class User < ActiveRecord::Base
  include HasWcaId

  PERMISSION_LEVELS = {
    regular: 0,
    admin: 1,
    superadmin: 2
  }.freeze

  has_secure_password
  validates :password, presence: { on: :create }, length: { minimum: 8 }, if: :password_digest_changed?

  validates :email, presence: true, if: :active?
  validates :email, email: true, allow_nil: true, allow_blank: true
  validates :email, uniqueness: true, allow_nil: true, allow_blank: true

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :permission_level, presence: true
  validates :permission_level, inclusion: { in: PERMISSION_LEVELS.values }, allow_nil: true, allow_blank: true

  validate :old_password_is_correct_when_changing_current_password_or_email

  auto_strip_attributes :email, :first_name, :last_name, :address

  has_many :permissions, inverse_of: :user, dependent: :destroy
  has_many :competitions, through: :permissions

  accepts_nested_attributes_for :permissions, allow_destroy: true

  has_many :owned_competitions,
    class_name: 'Competition',
    foreign_key: 'owner_user_id',
    dependent: :nullify

  has_many :delegating_competitions,
    class_name: 'Competition',
    foreign_key: 'delegate_user_id',
    dependent: :nullify

  scope :active, -> { where(active: true) }
  scope :delegates, ->{ where(delegate: true) }

  after_update :nullify_competition_delegate_user_ids
  before_save :increment_version

  attr_accessor :validate_old_password, :old_password

  def name
    "#{first_name} #{last_name}"
  end

  def policy
    @policy ||= UserPolicy.new(self)
  end

  def delegate_for?(competition)
    id == competition.delegate_user_id
  end

  def permission?(competition)
    permissions.any?{ |permission| permission.competition == competition }
  end

  def to_liquid
    @liquid_drop ||= UserDrop.new(self)
  end

  def session_data
    { 'id' => id, 'version' => version }
  end

  private

  def nullify_competition_delegate_user_ids
    return unless changed_attributes[:delegate] && !delegate
    delegating_competitions.each do |competition|
      competition.update_attributes(delegate_user_id: nil)
    end
  end

  def increment_version
    return unless password_digest_changed? || email_changed?
    self.version = version + 1
  end

  def old_password_is_correct_when_changing_current_password_or_email
    return unless validate_old_password
    return unless password_digest_changed? || email_changed?
    return if old_password.present? && BCrypt::Password.new(password_digest_was) == old_password
    errors.add(:old_password, "is not correct")
  end
end
