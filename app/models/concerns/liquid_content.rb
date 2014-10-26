module LiquidContent
  extend ActiveSupport::Concern

  included do
    validate :validate_content_has_no_liquid_errors
  end

  private

  def validate_content_has_no_liquid_errors
    Liquid::Template.parse(content)
  rescue Liquid::SyntaxError => e
    errors.add(:content, "Contains invalid Liquid code: #{e.message}")
  end
end
