require 'resolv'

class EmailDnsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless record.changes.key?(attribute)
    return unless value =~ EmailValidator::REGEXP
    return if mx_record?(value.split("@").last)
    record.errors.add(attribute, options[:message] || 'is not a valid email address')
  end

  private

  def mx_record?(domain)
    Resolv::DNS.open do |dns|
      mx = dns.getresources(domain.to_s, Resolv::DNS::Resource::IN::MX)
      return mx.any?
    end
  end
end
