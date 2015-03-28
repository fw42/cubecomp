class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value =~ /\A[^,\s]+@[^,\s]+\.[a-zA-Z]+\z/i
    record.errors[attribute] << (options[:message] || 'is not a valid email address')
  end
end
