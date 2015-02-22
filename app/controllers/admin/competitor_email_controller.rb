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

    success = if @activate
      activate_competitor
    else
      true
    end

    send_email if success
    redirect_to admin_competition_competitors_path(current_competition), flash: flashes(@activate, success)
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
    @competitor.save
  end

  def send_email
    CompetitorMailer.competitor_email(@email).deliver_now
  end

  def flashes(activate, success)
    if activate && success
      { notice: "Email to #{@email.to_email} sent and competitor successfully confirmed." }
    elsif activate && !success
      { error: "Failed to confirm competitor." }
    else
      { notice: "Email to #{@email.to_email} sent." }
    end
  end
end
