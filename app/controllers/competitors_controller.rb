class CompetitorsController < ApplicationController
  def search
    competitors = WCAGateway.new(ENV["WCA_API_URL"]).search_by_id params[:q]

    render json: competitors
  end
end
