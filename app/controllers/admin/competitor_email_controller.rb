class Admin::CompetitorEmailController < AdminController
  before_action :set_competitor, only: [:new, :create]

  def new
  end

  def create
  end

  private

  def set_competitor
    @competitor = current_competition.competitors.find(params[:id])
  end
end
