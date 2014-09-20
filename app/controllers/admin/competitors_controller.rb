class Admin::CompetitorsController < AdminController
  before_action :set_competitor, only: [:show, :edit, :update, :destroy]

  def index
    @competitors = current_competition.competitors.all
  end

  def show
  end

  def new
    @competition = current_competition
    @competitor = current_competition.competitors.new
  end

  def edit
  end

  def create
    @competition = current_competition
    @competitor = current_competition.competitors.new(competitor_params)

    if @competitor.save
      redirect_to admin_competitor_path(@competitor), notice: 'Competitor was successfully created.'
    else
      render :new
    end
  end

  def update
    if @competitor.update(competitor_params)
      redirect_to admin_competitor_path(@competitor), notice: 'Competitor was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @competitor.destroy
    redirect_to admin_competition_competitors_url(current_competition), notice: 'Competitor was successfully destroyed.'
  end

  private

  def set_competitor
    @competitor = current_competition.competitors.find(params[:id])
  end

  def competitor_params
    params.require(:competitor).permit(
      :first_name,
      :last_name,
      :wca,
      :email,
      :birthday,
      :country_id,
      :local,
      :staff,
      :user_comment,
      :admin_comment,
      :free_entrance,
      :free_entrance_reason,
      :paid,
      :paid_comment,
      :male
    )
  end
end
