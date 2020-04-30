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
    :gender,
    :state,
    :nametag,
    :confirmation_email_sent,
    days: [
      :status,
      events: [ :status ]
    ]
  ].freeze

  before_action :set_competitor, only: [:edit, :update, :confirm, :cancel, :destroy, :mark_as_paid]

  def index
    @competitors = current_competition
      .competitors
      .includes(:country)
      .includes(:day_registrations)
      .preload(:days)
      .includes(:event_registrations)
      .includes(:events)
      .order(created_at: :desc)

    @anniversaries = Wca::Person.anniversaries(@competitors.map(&:wca))
  end

  def nametags
    @competitors = current_competition
      .competitors
      .confirmed
      .includes(:country)
      .order(:last_name, :first_name)

    @wca_nametags = WcaNametagService.new(@competitors)

    render layout: 'admin/nametags'
  end

  def checklist
    @competitors = current_competition
      .competitors
      .confirmed
      .preload(:days)
      .preload(:day_registrations)
      .preload(event_registrations: :event)
      .includes(:country)
      .order('countries.name', :last_name, :first_name)

    @anniversaries = Wca::Person.anniversaries(@competitors.map(&:wca))

    render layout: 'admin/checklist'
  end

  def email_addresses
    active = current_competition
      .competitors
      .confirmed
      .includes(:event_registrations)

    @competitors = active.reject{ |competitor| competitor.event_registrations.empty? }
    @guests = active.select{ |competitor| competitor.event_registrations.empty? }
    @awaiting_payment = current_competition.competitors.awaiting_payment
    @locals = active.select(&:local)
  end

  def csv
    @exporter = CsvService.new(current_competition)
    @handles = @exporter.handles
    @active = @exporter.active_competitors
    @active_and_waiting = @exporter.active_and_waiting
    @active_guests = @exporter.active_guests
  end

  def csv_download_active
    exporter = CsvService.new(current_competition)
    active = exporter.active_competitors

    rows = []
    rows << exporter.header_to_csv
    rows += active.map{ |competitor| exporter.competitor_to_csv(competitor) }

    send_data rows.join("\n"), filename: "#{current_competition.name}.csv"
  end

  def new
    @competitor = current_competition.competitors.new
  end

  def edit
  end

  def create
    @competitor = current_competition.competitors.new
    @competitor.attributes = competitor_params.except(:days)
    RegistrationService.new(@competitor, admin: true).apply_registration_params(competitor_params[:days])

    if @competitor.save
      redirect_to admin_competition_competitors_path(current_competition),
        notice: 'Competitor was successfully created.'
    else
      render :new
    end
  end

  def update
    @competitor.attributes = competitor_params.except(:days)
    RegistrationService.new(@competitor, admin: true).apply_registration_params(competitor_params[:days])

    if @competitor.save
      redirect_to admin_competition_competitors_path(current_competition),
        notice: 'Competitor was successfully updated.'
    else
      render :edit
    end
  end

  def confirm
    if @competitor.update(state: 'confirmed')
      notice = { notice: 'Competitor was successfully confirmed.' }
    else
      Rails.logger.info("Failed to update: #{@competitor.errors.full_messages.inspect}")
      notice = { error: 'Failed to confirm competitor.' }
    end

    redirect_to admin_competition_competitors_path(current_competition), flash: notice
  end

  def mark_as_paid
    if @competitor.update(paid: true)
      notice = { notice: 'Competitor was successfully marked as paid.' }
    else
      Rails.logger.info("Failed to update: #{@competitor.errors.full_messages.inspect}")
      notice = { error: 'Failed to mark competitor as paid.' }
    end

    redirect_to admin_competition_competitors_path(current_competition), flash: notice
  end

  def cancel
    if @competitor.update(state: 'cancelled')
      notice = { notice: 'Competitor was successfully marked as cancelled.' }
    else
      Rails.logger.info("Failed to update: #{@competitor.errors.full_messages.inspect}")
      notice = { error: 'Failed to mark competitor as cancelled.' }
    end

    redirect_to admin_competition_competitors_path(current_competition), flash: notice
  end

  def destroy
    @competitor.destroy
    redirect_to admin_competition_competitors_url(current_competition),
      notice: 'Competitor was successfully deleted.'
  end

  private

  def set_competitor
    @competitor = current_competition.competitors.find(params[:id])
  end

  def competitor_params
    @competitor_params ||= params.require(:competitor).permit(PERMITTED_PARAMS)
  end
end
