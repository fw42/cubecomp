class Admin::CompetitorEmailController < AdminController
  before_action :set_competitor_and_email

  def new
  end

  def create
    @email.subject = email_params[:subject]
    @email.content = email_params[:content]

    unless @email.valid?
      render :new
      return
    end

    CompetitorMailer.competitor_email(@email).deliver_now

    flashes = if @activate
      activate_competitor
    else
      { notice: "Email to #{@email.to_email} sent." }
    end

    redirect_to admin_competition_competitors_path(current_competition), flashes
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
    @email = CompetitorEmail.for_competitor(@competitor)
    @activate = params[:activate]
  end

  def activate_competitor
    @competitor.state = 'confirmed'
    @competitor.confirmation_email_sent = true

    if @competitor.save
      { notice: "Email to #{@email.to_email} sent and competitor successfully confirmed." }
    else
      { error: "Email to #{@email.to_email} sent, but failed to confirm competitor." }
    end
  end
end
