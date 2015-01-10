class CompetitionArea::CompetitorsController < CompetitionAreaController
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
    :user_comment,
    :male,
    days: [
      :status,
      events: [ :status ]
    ]
  ]

  skip_before_action :load_theme_file

  def create
    competitor = @competition.competitors.new
    competitor.attributes = competitor_params.except(:days)

    RegistrationService.new(competitor).apply_registration_params(competitor_params[:days])

    if competitor.save
      # TODO: I18n
      redirect_to :back, notice: 'Registration successful.'
    else
      load_theme_file
      theme_file_renderer.default_locals[:@competitor] = competitor
      render_theme_file
    end
  end

  private

  def load_theme_file
    @theme_file = @competition.theme_files.find_by!(filename: params[:theme_file])
  end

  def competitor_params
    @competitor_params ||= params.require(:competitor).permit(PERMITTED_PARAMS)
  end
end
