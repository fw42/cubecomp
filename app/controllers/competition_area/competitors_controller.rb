class CompetitionArea::CompetitorsController < CompetitionAreaController
  class InvalidReturnToPath < StandardError; end

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
      redirect_to return_to_path, notice: t(:registration_success)
    else
      render_theme_file_with_errors(competitor)
    end
  end

  private

  def return_to_path
    path = params[:return_to_path]
    if path && path =~ /\A\//
      path
    else
      raise InvalidReturnToPath
    end
  end

  def render_theme_file_with_errors(competitor)
    load_theme_file
    theme_file_renderer.default_locals[:@competitor] = competitor
    theme_file_renderer.default_locals[:@return_to_path] = return_to_path
    render_theme_file
  end

  def load_theme_file
    @theme_file = @competition.theme_files.find_by!(filename: params[:theme_file])
  end

  def competitor_params
    @competitor_params ||= params.require(:competitor).permit(PERMITTED_PARAMS)
  end
end
