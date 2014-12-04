class WCAGateway
  class ConnectionError < StandardError
    def initialize(exception)
      @exception = exception
    end
  end

  Competitor = Struct.new(:id, :name, :gender, :country)

  def initialize(url)
    @conn = Faraday.new(url: url) do |faraday|
      faraday.request :url_encoded
      faraday.response(:logger) unless Rails.env.test?
      faraday.adapter Faraday.default_adapter
      faraday.use Faraday::Response::RaiseError
    end
  end

  def search_by_id(q)
    response = @conn.get "/competitors?q=#{q}"
    JSON.parse(response.body)["competitors"].map do |c|
      Competitor.new(c["id"], c["name"], c["gender"], c["country"])
    end

  rescue Faraday::ConnectionFailed => e
    raise WCAGateway::ConnectionError.new(e)
  # ClientError is Faraday's most generic error
  rescue Faraday::ClientError => e
    raise WCAGateway::ConnectionError.new(e)
  rescue JSON::ParserError => e
    raise WCAGateway::ConnectionError.new(e)
  end
end