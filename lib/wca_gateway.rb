class WCAGateway
  Competitor = Struct.new(:id, :name, :gender, :country)

  def initialize(url)
    @conn = Faraday.new(url: url) do |faraday|
      faraday.request :url_encoded
      unless Rails.env.test?
        faraday.response :logger
      end
      faraday.adapter Faraday.default_adapter
    end
  end

  def search_by_id(q)
    response = @conn.get "/competitors?q=#{q}"
    JSON.parse(response.body)["competitors"].map do |c|
      Competitor.new(c["id"], c["name"], c["gender"], c["country"])
    end
  end
end
