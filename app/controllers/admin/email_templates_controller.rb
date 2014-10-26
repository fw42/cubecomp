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
    params.require(:email_template).permit(:name, :content)
  end
end
