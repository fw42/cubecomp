class WcaController < ApplicationController
  MIN_QUERY_LENGTH = 6

  def autocomplete
    query = params[:q].to_s.strip

    unless query =~ /\A[\d\w]+\z/
      render json: { error: 'invalid query' }
      return
    end

    if query.size < MIN_QUERY_LENGTH
      render json: { error: "query needs to be at least #{MIN_QUERY_LENGTH} characters" }
      return
    end

    render json: Wca::Person.query(query)
  end
end
