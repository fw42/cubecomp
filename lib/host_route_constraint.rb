class HostRouteConstraint
  def initialize(*domains, negate: false)
    @domains = domains.reject(&:blank?)
    @negate = negate
  end

  def matches?(request)
    return true if @domains.empty? && !Rails.env.production?
    @domains.include?(request.host) ^ @negate
  end
end
