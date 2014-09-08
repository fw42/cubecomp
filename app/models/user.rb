class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :email, presence: true
  validates :email, email: true, allow_nil: true, allow_blank: true
  validates :email, uniqueness: true, allow_nil: true, allow_blank: true

  validates :first_name, presence: true
  validates :last_name, presence: true

  has_many :permissions, dependent: :destroy
  has_many :competitions, through: :permissions

  has_many :delegating_competitions, class_name: 'Competition', foreign_key: 'delegate_user_id', dependent: :nullify

  scope :delegates, ->{ where(delegate: true) }

  after_update :nullify_competition_delegate_user_ids

  def name
    "#{first_name} #{last_name}"
  end

  def policy
    @policy ||= UserPolicyService.new(self)
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
