class LiquidValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    Liquid::Template.parse(value, line_numbers: true)
  rescue Liquid::SyntaxError => e
    msg = if e.line_number
      "contains invalid Liquid code on line #{e.line_number}: #{e.to_s(false)}"
    else
      "contains invalid Liquid code: #{e.message}"
    end

    record.errors.add(attribute, msg)
  end
end
