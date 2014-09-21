module Admin::CompetitionsHelper
  def competition_for_form(competition)
    missing_locales = Locale::ALL.keys - competition.locales.map(&:handle)
    missing_locales.each do |locale|
      competition.locales.build(handle: locale)
    end
    competition
  end
end