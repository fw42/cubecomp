class CompetitorsController < ApplicationController
  def search
    ENV["WCA_API_URL"] ||= 'http://178.62.217.148'

    competitors = WCAGateway.new(ENV["WCA_API_URL"]).search_by_id params[:q]

    render json: competitors
  end
end
