class CompetitorsController < ApplicationController
  def search
    ENV["WCA_API_URL"] ||= 'http://178.62.217.148'
    conn = Faraday.new(:url => ENV["WCA_API_URL"]) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end

    response = conn.get "/competitors?q=#{params[:term]}"
    json = JSON.parse(response.body)

    render json: json["competitors"]
  end
end
