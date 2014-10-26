class CompetitorEmail
  include ActiveModel::Validations
  include ActiveModel::Model

  attr_accessor :from_name, :from_email, :to_name, :to_email, :cc_email, :subject, :template

  validates :from_name, presence: true
  validates :to_name, presence: true

  validates :from_email, presence: true
  validates :from_email, email: true, allow_nil: true, allow_blank: true

  validates :to_email, presence: true
  validates :to_email, email: true, allow_nil: true, allow_blank: true

  validates :subject, presence: true
  validates :template, presence: true
end
