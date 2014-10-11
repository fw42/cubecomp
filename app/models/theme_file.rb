class ThemeFile < ActiveRecord::Base
  belongs_to :competition
  validates :competition, presence: true

  validates :filename, presence: true
  validates :filename, uniqueness: { scope: :competition_id }, allow_nil: true, allow_blank: true

  scope :for_filename, lambda { |name, locale, extension|
    filenames = [
      "#{name}.#{locale}.#{extension}",
      "#{name}.#{extension}",
    ]

    order_query_segments = filenames.map do |file|
      "filename = \"#{ThemeFile.connection.quote_string(file)}\" DESC"
    end

    where(filename: filenames).order(order_query_segments.join(', '))
  }

  validate :validate_template_errors

  private

  def validate_template_errors
    Liquid::Template.parse(content)
  rescue Liquid::SyntaxError => e
    errors.add(:content, "Contains invalid Liquid code: #{e.message}")
  end
end
