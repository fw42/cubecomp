class Admin::CompetitionsController < AdminController
  before_action :set_competition, only: [:edit, :update, :destroy]
  skip_before_filter :ensure_current_competition
  before_action :ensure_user_can_create_competitions, only: [:index, :new, :create]
  before_action :ensure_user_can_destroy_competition, only: [:index, :destroy]

  def index
    @competitions = Competition.all
  end

  def new
    @competition = Competition.new
  end

  def create
    @competition = Competition.new(competition_params)

    if @competition.save
      redirect_to admin_competitions_path, notice: 'Competition was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @competition.update(competition_params)
      redirect_to edit_admin_competition_path(@competition), notice: 'Competition was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @competition.destroy
    redirect_to admin_competitions_url, notice: 'Competition was successfully destroyed.'
  end

  private

  def ensure_user_can_create_competitions
    if !current_user.policy.create_competitions?
      render_unauthorized
    end
  end

  def ensure_user_can_destroy_competition
    if !current_user.policy.destroy_competition?(@competition)
      render_unauthorized
    end
  end

  def set_competition
    @competition = Competition.find(params[:id])
  end

  def competition_params
    params.require(:competition).permit(
      :name,
      :handle,
      :delegate_user_id,
      :staff_email,
      :staff_name,
      :city_name,
      :city_name_short,
      :venue_address,
      :country_id,
      :cc_orga,
      :registration_open,
      locales_attributes: [:id, :handle, :_destroy],
      days_attributes: [
        :id,
        :"date(3i)",
        :"date(2i)",
        :"date(1i)",
        :"entrance_fee_competitors",
        :"entrance_fee_guests",
        :_destroy
      ]
    )
  end
end
