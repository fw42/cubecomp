class CompetitionDrop < Liquid::Drop
  def initialize(competition)
    @competition = competition
  end

  delegate :name,
    :handle,
    :staff_email,
    :staff_name,
    :city_name,
    :venue_address,
    :delegate,
    to: :@competition

  def country
    @competition.country.name
  end
end
