class Admin::CompetitionsController < AdminController
  before_action :set_competition, only: [:edit, :update, :destroy]

  def index
    @competitions = Competition.all
  end

  def new
    @competition = Competition.new
  end

  def edit
  end

  def create
    @competition = Competition.new(competition_params)

    if @competition.save
      redirect_to admin_competitions_path, notice: 'Competition was successfully created.'
    else
      render :new
    end
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

  def set_competition
    @competition = Competition.find(params[:id])
  end

  def competition_params
    params.require(:competition).permit(:name, :handle, :staff_email, :staff_name, :city_name, :city_name_short, :venue_address, :country_id, :cc_orga, :registration_open)
  end
end
