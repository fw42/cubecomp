class Importer::Competition < Importer
  def initialize(handle)
    @handle = handle
    @competition = ::Competition.new
    @legacy_configuration = LegacyConfiguration.first
  end

  def import
    import_values
    import_country
    import_days
    import_emails
    build_locales

    @competition
  end

  private

  def import_values
    @competition.handle = @handle

    assign_values(@competition, @legacy_configuration, {
      :name => :competition_name,
      :staff_email => :orga_email,
      :staff_name => :orga_email_name,
      :city_name => :local,
      :city_name_short => :local_short,
      :registration_open => :registration_open,
      :cc_orga => :use_mail_cc
    })

    @competition.published = true
  end

  def import_country
    legacy_country = LegacyCountry.find_by!(id: @legacy_configuration.default_country)
    country = Country.find_by!(name: legacy_country.name)
    @competition.country_id = country.id
  end

  def parse_fees(str)
    str
      .split(",")
      .map(&:strip)
      .map{ |str| BigDecimal.new(str) }
  end

  def import_days
    legacy_fees = parse_fees(@legacy_configuration.entrance_fees)
    legacy_guest_fees = parse_fees(@legacy_configuration.entrance_fee_guests)

    @legacy_configuration.days.times do |i|
      @competition.days.build(
        date: @legacy_configuration.first_day + i.days,
        entrance_fee_competitors: legacy_fees[i],
        entrance_fee_guests: legacy_guest_fees[i]
      )
    end
  end

  def import_emails
    if @legacy_configuration.mail_text.present?
      @competition.email_templates.build(
        name: "Confirmation email",
        subject: "[{{ competition.name }}] {{ competitor.name }}",
        content: convert_email(@legacy_configuration.mail_text)
      )
    end

    if @legacy_configuration.mail_text_guests.present?
      @competition.email_templates.build(
        name: "Confirmation email (guests)",
        subject: "[{{ competition.name }}] {{ competitor.name }}",
        content: convert_email(@legacy_configuration.mail_text_guests)
      )
    end
  end

  def convert_email(text)
    text
      .gsub("COMPETITION_NAME", "{{ competition.name }}")
      .gsub("FIRST_NAME", "{{ competitor.first_name }}")
      .gsub("LAST_NAME", "{{ competitor.last_name }}")
      .gsub("ADMIN_NAME", "{{ user.name }}")
      .gsub("Sébastien", "{{ user.name }}")
      .gsub("EVENTS.", "EVENTS")
      .gsub("EVENTS",
        "\n" \
        "{% for registration in competitor.registrations %}\n" \
        "- {{ registration.name }}{% if registration.waiting %} (waiting list){% endif %}" \
        "{% endfor %}"
      )
  end

  def build_locales
    @competition.default_locale = @competition.locales.build(handle: 'de')
    @competition.locales.build(handle: 'en')
  end
end
