class LiquidValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    Liquid::Template.parse(value)
  rescue Liquid::SyntaxError => e
    record.errors.add(attribute, "contains invalid Liquid code: #{e.message}")
  end
end
