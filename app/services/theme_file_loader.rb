class ThemeFileLoader
  def initialize(relation)
    @relation = relation
  end

  def find_by(**args)
    where(**args).first
  end

  def find_by!(**args)
    where(**args).first!
  end

  private

  def where(filename:, locale:)
    base, extension = split(filename)

    filenames = []
    filenames << [ base, locale, extension ].join('.')
    filenames << [ base, extension ].join('.')

    order_query_segments = filenames.map do |file|
      "filename = \"#{ThemeFile.connection.quote_string(file)}\" DESC"
    end

    @relation.where(filename: filenames).order(Arel.sql(order_query_segments.join(', ')))
  end

  def split(filename)
    file_extension_matcher = /\A(.*?)(\.(.*))?\z/
    matches = file_extension_matcher.match(filename)
    [ matches[1], matches[3] ]
  end
end
