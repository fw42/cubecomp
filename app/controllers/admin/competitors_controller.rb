class Admin::CompetitorsController < AdminController
  PERMITTED_PARAMS = [
    :first_name,
    :last_name,
    :wca,
    :email,
    :"birthday(1i)",
    :"birthday(2i)",
    :"birthday(3i)",
    :country_id,
    :local,
    :staff,
    :user_comment,
    :admin_comment,
    :free_entrance,
    :free_entrance_reason,
    :paid,
    :paid_comment,
    :male,
    :state,
    :nametag,
    :confirmation_email_sent
  ]

  before_action :set_competitor, only: [:edit, :update, :destroy]

  def index
    @competitors = current_competition.competitors.all
  end

  def new
    @competitor = current_competition.competitors.new
  end

  def edit
  end

  def create
    @competitor = current_competition.competitors.new(competitor_params)

    if @competitor.save
      redirect_to admin_competition_competitor_path(current_competition, @competitor),
        notice: 'Competitor was successfully created.'
    else
      render :new
    end
  end

  def update
    if @competitor.update(competitor_params)
      redirect_to admin_competition_competitor_path(current_competition, @competitor),
        notice: 'Competitor was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @competitor.destroy
    redirect_to admin_competition_competitors_url(current_competition),
      notice: 'Competitor was successfully destroyed.'
  end

  private

  def set_competitor
    @competitor = current_competition.competitors.find(params[:id])
  end

  def competitor_params
    params.require(:competitor).permit(PERMITTED_PARAMS)
  end
end
