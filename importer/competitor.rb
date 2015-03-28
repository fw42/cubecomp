class Importer::Competitor < Importer
  def import
    LegacyCompetitor.find_each do |legacy|
      competitor = @competition.competitors.build
      legacy_country = LegacyCountry.find_by!(id: legacy.country_id)
      country = Country.find_by!(name: legacy_country.name)
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

      competitor.email = legacy.mail.gsub(/\s/, '')

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

      days = @competition.days.sort_by(&:date)

      legacy.days.each do |i|
        registration = competitor.day_registrations.build(competition_id: @competition.id, day: days[i])
        registration.updated_at = registration.created_at = legacy.created_at
      end

      LegacyRegistration.where(competitor_id: legacy.id).find_each do |legacy_registration|
        registration = competitor.event_registrations.build(
          competition_id: @competition.id,
          waiting: !!legacy_registration.waiting,
          updated_at: legacy_registration.updated_at,
          created_at: legacy_registration.created_at
        )
        registration.event_id = Importer::Event::MAPPING[legacy_registration.event_id]
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
      end

      competitor.save!
    end
  end
end
