class WcaNametagService
  def initialize(competitors)
    @competitors = competitors
  end

  def nametag(wca_id)
    number = number_of_competitions[wca_id]
    return if number == 0
    lines = []
    lines << "#{number.ordinalize} competition"
    lines << rubiks_cube_nametag_line(wca_id)
    lines.compact.join("<br/>\n")
  end

  def rubiks_cube_nametag_line(wca_id)
    return unless single = rubiks_cube_singles[wca_id]
    average = rubiks_cube_averages[wca_id]

    single = WcaTime.new('333', single.first.best)
    str = "<b>3x3:</b> #{single}"
    str << " (#{WcaTime.new('333', average.first.best)})" if average
    str
  end

  private

  def number_of_competitions
    @number_of_competitions ||= Wca::Person.number_of_competitions(wca_ids)
  end

  def rubiks_cube_singles
    @rubiks_cube_singles ||= Wca::RanksSingle.for_event(wca_ids, '333')
  end

  def rubiks_cube_averages
    @rubiks_cube_averages ||= Wca::RanksAverage.for_event(wca_ids, '333')
  end

  def wca_ids
    @wca_ids ||= @competitors.map(&:wca).compact
  end
end
