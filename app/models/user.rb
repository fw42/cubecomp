class User < ActiveRecord::Base
  PERMISSION_LEVELS = {
    :regular => 0,
    :admin => 1,
    :superadmin => 2
  }

  has_secure_password

  validates :email, presence: true
  validates :email, email: true, allow_nil: true, allow_blank: true
  validates :email, uniqueness: true, allow_nil: true, allow_blank: true

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :permission_level, presence: true
  validates :permission_level, inclusion: { in: PERMISSION_LEVELS.values }, allow_nil: true, allow_blank: true

  has_many :permissions, dependent: :destroy
  has_many :competitions, through: :permissions

  accepts_nested_attributes_for :permissions, allow_destroy: true

  has_many :delegating_competitions, class_name: 'Competition', foreign_key: 'delegate_user_id', dependent: :nullify

  scope :delegates, ->{ where(delegate: true) }

  after_update :nullify_competition_delegate_user_ids

  def name
    "#{first_name} #{last_name}"
  end

  def policy
    @policy ||= UserPolicyService.new(self)
  end

  def delegate_for?(competition)
    id == competition.delegate_user_id
  end

  def has_permission?(competition)
    permissions.where(competition: competition).exists?
  end

  private

  def nullify_competition_delegate_user_ids
    if changed_attributes[:delegate] && !delegate
      delegating_competitions.each do |competition|
        competition.update_attribute(:delegate_user_id, nil)
      end
    end
  end
end
