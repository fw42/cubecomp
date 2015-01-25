class Admin::EmailTemplatesController < AdminController
  before_action :set_template, only: [:edit, :update, :destroy]

  def index
    @templates = current_competition.email_templates.all
  end

  def new
    @template = current_competition.email_templates.new
  end

  def edit
  end

  def import_templates_form
    @options = Competition
      .joins(:email_templates)
      .select('competitions.id, competitions.name, COUNT(email_templates.id)')
      .where.not('competitions.id' => current_competition.id)
      .group('competitions.id, competitions.name')
      .pluck('competitions.id, competitions.name, COUNT(email_templates.id)')
      .map{ |id, name, count| [ "#{name} (#{count} #{"template".pluralize(count)})", id ] }
  end

  def import_templates
    from_competition = Competition.find_by!(id: params[:from_competition_id])
    return render_forbidden unless current_user.policy.login?(from_competition)

    EmailTemplate.transaction do
      EmailTemplatesImportService.new(from_competition, current_competition).replace!
    end

    redirect_to admin_competition_email_templates_path(current_competition),
      notice: 'Templates were successfully imported.'
  end

  def create
    @template = current_competition.email_templates.new(template_params)

    if @template.save
      redirect_to admin_competition_email_templates_path(current_competition),
        notice: 'Template was successfully created.'
    else
      render :new
    end
  end

  def update
    if @template.update(template_params)
      redirect_to admin_competition_email_templates_path(current_competition),
        notice: 'Template was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @template.destroy
    redirect_to admin_competition_email_templates_path(current_competition),
      notice: 'Template was successfully deleted.'
  end

  private

  def set_template
    @template = current_competition.email_templates.find(params[:id])
  end

  def template_params
    params.require(:email_template).permit(:name, :content, :subject)
  end
end
