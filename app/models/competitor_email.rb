class CompetitorEmail
  include ActiveModel::Validations
  include ActiveModel::Model

  attr_accessor :from_name, :from_email, :to_name, :to_email, :cc_name, :cc_email, :subject, :content

  validates :from_name, presence: true
  validates :to_name, presence: true

  validates :from_email, presence: true
  validates :from_email, email: true, allow_nil: true, allow_blank: true

  validates :to_email, presence: true
  validates :to_email, email: true, allow_nil: true, allow_blank: true

  validates :subject, presence: true
  validates :content, presence: true

  def self.for_competitor(competitor)
    competition = competitor.competition

    attributes = {
      from_name: competition.staff_name || competition.name,
      from_email: competition.staff_email,
      to_name: competitor.name,
      to_email: competitor.email,
    }

    if competition.cc_orga?
      attributes[:cc_name] = competition.staff_name
      attributes[:cc_email] = competition.staff_email
    end

    new(attributes)
  end
end
