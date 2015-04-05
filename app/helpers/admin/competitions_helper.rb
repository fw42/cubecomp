module Admin::CompetitionsHelper
  def competition_for_form(competition)
    missing_locales = Locale::ALL.keys - competition.locales.map(&:handle)
    missing_locales.each do |locale|
      locale = competition.locales.build(handle: locale)
      locale.mark_for_destruction if competition.persisted? || competition.errors.any?
    end

    if competition.days.size == 0
      competition.days.build(
        entrance_fee_guests: 0,
        entrance_fee_competitors: 0
      )
    end

    competition
  end
end
