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
    :male,
    :state,
    :nametag,
    :confirmation_email_sent,
    days: [
      :status,
      events: [ :status ]
    ]
  ]

  before_action :set_competitor, only: [:edit, :update, :destroy]

  def index
    @competitors = current_competition.competitors.all
  end

  def new
    @competitor = current_competition.competitors.new
  end

  def edit
  end

  def create
    @competitor = current_competition.competitors.new

    if apply_params_and_save_competitor_with_registrations(@competitor)
      redirect_to admin_competition_competitor_path(current_competition, @competitor),
        notice: 'Competitor was successfully created.'
    else
      render :new
    end
  end

  def update
    if apply_params_and_save_competitor_with_registrations(@competitor)
      redirect_to edit_admin_competition_competitor_path(current_competition, @competitor),
        notice: 'Competitor was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @competitor.destroy
    redirect_to admin_competition_competitors_url(current_competition),
      notice: 'Competitor was successfully destroyed.'
  end

  private

  def apply_params_and_save_competitor_with_registrations(competitor)
    Competitor.transaction do
      competitor.attributes = competitor_params.except(:days, :keys)
      competitor.save!
      apply_registration_params(competitor) if competitor_params[:days]
      competitor
    end
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def apply_registration_params(competitor)
    service = RegistrationService.new(competitor)

    competitor_params[:days].each do |day_id, day_attributes|
      if day_attributes[:status] == 'not_registered'
        service.unregister_from_day!(day_id)
        next
      elsif day_attributes[:status] == 'guest'
        service.register_as_guest!(day_id)
        next
      end

      apply_event_registration_params(service, day_attributes[:events])
    end
  end

  def apply_event_registration_params(service, attributes)
    attributes.each do |event_id, event_attributes|
      if event_attributes[:status] == 'not_registered'
        service.unregister_from_event!(event_id)
      else
        service.register_for_event!(Event.find(event_id), event_attributes[:status] == 'waiting')
      end
    end
  end

  def set_competitor
    @competitor = current_competition.competitors.find(params[:id])
  end

  def competitor_params
    @competitor_params ||= params.require(:competitor).permit(PERMITTED_PARAMS)
  end
end
