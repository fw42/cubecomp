class Importer::Competitor < Importer
  def import
    LegacyCompetitor.find_each do |legacy|
      next if ['inwaxishina', 'Asydaysew', 'Invoiveimpeli', 'flielidacof'].include?(legacy.first_name)
      next if legacy.first_name == legacy.last_name
      # next if legacy.birthday == Date.parse('1900-01-01')

      competitor = @competition.competitors.build
      legacy_country = LegacyCountry.find_by!(id: legacy.country_id)

      if legacy_country.name == "Iran, Islamic Republic Of"
        legacy_country.name = 'Iran'
      elsif legacy_country.name == 'Russian Federation'
        legacy_country.name = 'Russia'
      elsif legacy_country.name == "Korea, Republic Of"
        legacy_country.name = 'Korea'
      elsif legacy_country.name == 'United States'
        legacy_country.name = 'USA'
      end

      begin
        country = Country.find_by!(name: legacy_country.name)
      rescue
        byebug
      end
      competitor.country = country

      assign_values(competitor, legacy, {
        :first_name => :first_name,
        :last_name => :last_name,
        :wca => :wca_id,
        :birthday => :birthday,
        :local => :local,
        :staff => :orga,
        :user_comment => :user_comment,
        :admin_comment => :admin_comment,
        :free_entrance => :free_entrance,
        :free_entrance_reason => :free_entrance_reason,
        :male => :male,
        :confirmation_email_sent => :mail_sent,
      })

      if legacy.wca_id
        if legacy.wca_id.upcase == 'RIJK200801'
          competitor.wca = '2008RIJK01'
        elsif legacy.wca_id.upcase == 'OEYM200701'
          competitor.wca = '2006OEYM01'
        end
      end

      if legacy.mail
        competitor.email = legacy.mail.gsub(/\s/, '').gsub("\xe2\x80\x8b", "").gsub(/[<>]/, '')
      else
        competitor.email = 'missing@cubecomp.de'
      end

      if competitor.email == 'mikiulas@hotmail.com,kalidulas@hotmail.com'
        competitor.email = 'kalidulas@hotmail.com'
      end

      if competitor.email == 'o,kejs@gmx.de'
        competitor.email = 'o.kejs@gmx.de'
      end

      if competitor.email == 'luki10@live.at­'
        competitor.email = 'luki10@live.at'
      end

      if legacy.respond_to?(:paid)
        competitor.paid = legacy.paid
      else
        competitor.paid = false
      end

      if legacy.respond_to?(:nametag_extra)
        competitor.nametag = legacy.nametag_extra
      end

      if legacy.active
        competitor.state = 'confirmed'
      else
        if legacy.updated_at == legacy.created_at
          competitor.state = 'new'
        else
          competitor.state = 'disabled'
        end
      end

      if legacy.respond_to?(:days)
        days = @competition.days.sort_by(&:date)

        legacy.days.each do |i|
          registration = competitor.day_registrations.build(competition_id: @competition.id, day: days[i])
          registration.updated_at = registration.created_at = legacy.created_at
        end
      end

      LegacyRegistration.where(competitor_id: legacy.id).find_each do |legacy_registration|
        registration = competitor.event_registrations.build(
          competition_id: @competition.id,
          waiting: !!legacy_registration.waiting,
          updated_at: legacy_registration.updated_at,
          created_at: legacy_registration.created_at
        )
        registration.event_id = Importer::Event::MAPPING[legacy_registration.event_id]

        RegistrationService.new(competitor).register_for_day(registration.event.day.id)

        if registration.event.name == 'Lunch'
          competitor.event_registrations.delete(registration)
        end
      end

      if (!legacy.respond_to?(:days) || (legacy.respond_to?(:days) && legacy.days == [])) && LegacyRegistration.where(competitor_id: legacy.id).size == 0
        days = @competition.days.sort_by(&:date)
        days.each do |day|
          RegistrationService.new(competitor).register_for_day(day.id)
        end
      end

      if !competitor.valid?
        if competitor.errors[:email] && competitor.email == 'EineEmail@NocheineEmail!.de'
          @competition.competitors.delete(competitor)
          next
        end

        if competitor.state == 'new' && competitor.errors[:wca]
          @competition.competitors.delete(competitor)
          next
        end

        p competitor
        byebug
      end

      competitor.save!
    end
  end
end
