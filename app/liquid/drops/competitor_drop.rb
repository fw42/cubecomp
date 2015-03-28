class CompetitorDrop < Liquid::Drop
  def initialize(competitor)
    @competitor = competitor
  end

  delegate :name, :first_name, :last_name, :email, to: :@competitor

  def registrations
    @competitor
      .event_registrations
      .preload(event: :day)
      .sort_by{ |registration| [ registration.event.day.date, registration.event.start_time ] }
  end
end
