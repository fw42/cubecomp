class EmailValidator < ActiveModel::EachValidator
  REGEXP = /\A[^,\s]+@[^,\s]+\.[a-zA-Z]+\z/i.freeze

  def validate_each(record, attribute, value)
    return if value =~ REGEXP
    record.errors.add(attribute, options[:message] || 'is not a valid email address')
  end
end
