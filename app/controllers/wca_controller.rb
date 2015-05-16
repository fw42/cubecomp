class WcaController < ApplicationController
  def autocomplete
    query = params[:q]

    unless query.is_a?(String)
      render json: { error: 'invalid query' }
      return
    end

    if query.size < WcaGateway::MIN_QUERY_LENGTH
      render json: { error: "query needs to be at least #{WcaGateway::MIN_QUERY_LENGTH} characters" }
      return
    end

    competitors = DEPENDENCIES.fetch(:wca_gateway).search_by_id(query)
    render json: competitors
  end
end
