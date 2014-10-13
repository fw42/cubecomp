class Admin::EventsController < AdminController
  before_action :set_event, only: [:edit, :update, :destroy, :registrations]

  PERMITTED_PARAMS = [
    :name_short,
    :name,
    :handle,

    :day_id,
    :start_time,
    :length_in_minutes,

    :round,
    :timelimit,
    :format,
    :proceed,
    :max_number_of_registrations,
    :state
  ]

  def index
    @events = current_competition.events.includes(:registrations)
  end

  def new
    @event = current_competition.events.new
  end

  def edit
  end

  def create
    @event = current_competition.events.new(event_params)

    if @event.save
      redirect_to admin_competition_event_path(current_competition, @event),
        notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to edit_admin_competition_event_path(current_competition, @event),
        notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to admin_competition_events_url(current_competition),
      notice: 'Event was successfully destroyed.'
  end

  private

  def set_event
    @event = current_competition.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(PERMITTED_PARAMS)
  end
end
