class Importer::News < Importer
  def import
    LegacyNews.find_each do |legacy|
      locale = @competition.locales.detect{ |locale| locale.handle == legacy.locale }

      next unless locale

      @competition.news.build(
        time: legacy.datetime,
        locale: locale,
        text: legacy.text,
        updated_at: legacy.datetime,
        created_at: legacy.datetime,
      )
    end
  end
end
