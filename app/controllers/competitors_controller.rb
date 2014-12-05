class CompetitorsController < ApplicationController
  def search
    competitors = WcaGateway.new(Cubecomp::Application.config.wca_api_url).search_by_id(params[:q])

    render json: competitors
  end
end
