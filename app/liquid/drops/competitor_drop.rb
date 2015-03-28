class CompetitorDrop < Liquid::Drop
  def initialize(competitor)
    @competitor = competitor
  end

  delegate :name, :first_name, :last_name, :email, to: :@competitor

  def registrations
    @competitor.event_registrations.joins(event: :day).order('days.date ASC, events.start_time')
  end
end
