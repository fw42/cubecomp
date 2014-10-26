class Admin::CompetitorEmailController < AdminController
  before_action :set_competitor_and_email

  def new
  end

  def create
    @email.subject = email_params[:subject]
    @email.content = email_params[:content]

    if @email.valid?
      # TODO
      @email.deliver
    else
      render :new
    end
  end

  def render_template
    template = current_competition.email_templates.find(params[:email_template_id])
    renderer = EmailTemplateRenderer.new(template, @competitor, current_user)
    respond_to do |format|
      format.json do
        render json: {
          subject: renderer.render_subject,
          content: renderer.render_content
        }
      end
    end
  end

  private

  def email_params
    params.require(:competitor_email).permit(:subject, :content)
  end

  def set_competitor_and_email
    @competitor = current_competition.competitors.find(params[:id])

    email_attributes = {
      from_name: current_competition.staff_name,
      from_email: current_competition.staff_email,
      to_name: @competitor.name,
      to_email: @competitor.email,
    }

    if current_competition.cc_orga?
      email_attributes[:cc_name] = current_competition.staff_name
      email_attributes[:cc_email] = current_competition.staff_email
    end

    @email = CompetitorEmail.new(email_attributes)

    @activate = params[:activate]
  end
end
