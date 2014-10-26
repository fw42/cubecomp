module Admin::CompetitorsHelper
  def events_by_day_list(competitor)
    str = ''
    by_day = competitor.event_registrations_by_day(true)
    by_day.each_key do |day|
      next if by_day[day].empty?
      str << '<br>\n' unless str.blank?
      str << "<b>#{day.date.strftime('%A')}</b><br>\n"
      by_day[day].each do |registration|
        str << registration.event.name
        str << ' (waiting)' if registration.waiting
        str << '<br>\n'
      end
    end
    str
  end
end
