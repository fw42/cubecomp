class WcaGateway
  MIN_QUERY_LENGTH = 6

  class ConnectionError < StandardError
    def initialize(exception)
      @exception = exception
    end
  end

  Competitor = Struct.new(:id, :name, :gender, :country, :competition_count)

  def initialize(url)
    @conn = Faraday.new(url: url) do |faraday|
      faraday.request(:url_encoded)
      faraday.response(:logger) unless Rails.env.test?
      faraday.adapter(Faraday.default_adapter)
      faraday.use(Faraday::Response::RaiseError)
    end
  end

  def search_by_id(q)
    q = q.strip.upcase
    response = get("/competitors?q=#{q}")

    JSON.parse(response.body)["competitors"].map do |c|
      Competitor.new(c["id"], c["name"], c["gender"], c["country"])
    end
  rescue Faraday::ConnectionFailed => e
    raise WcaGateway::ConnectionError.new(e)
  # ClientError is Faraday's most generic error
  rescue Faraday::ClientError => e
    raise WcaGateway::ConnectionError.new(e)
  rescue JSON::ParserError => e
    raise WcaGateway::ConnectionError.new(e)
  end

  def find_by_id(id)
    response = get("/competitors/#{id}")
    c = JSON.parse(response.body)["competitor"]
    Competitor.new(c["id"], c["name"], c["gender"], c["country"], c["competition_count"])
  rescue Faraday::ResourceNotFound
    nil
  end

  private

  def get(url)
    @conn.get do |req|
      req.url(url)
      req.options = { timeout: 1, open_timeout: 1 }
    end
  end
end
