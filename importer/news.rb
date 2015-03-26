class Importer::News < Importer
  def import
    LegacyNews.find_each do |legacy|
      @competition.news.build(
        time: legacy.datetime,
        locale: @competition.locales.detect{ |locale| locale.handle == legacy.locale },
        text: legacy.text,
        updated_at: legacy.datetime,
        created_at: legacy.datetime,
      )
    end
  end
end
