class Admin::EventsController < AdminController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = current_competition.events.all
  end

  def show
  end

  def new
    @competition = current_competition
    @event = current_competition.events.new
  end

  def edit
  end

  def create
    @competition = current_competition
    @event = current_competition.events.new(event_params)

    if @event.save
      redirect_to admin_event_path(@event), notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to admin_event_path(@event), notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to admin_competition_events_url(current_competition), notice: 'Event was successfully destroyed.'
  end

  private

  def set_event
    @event = current_competition.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :day_id,
      :handle,
      :name_short,
      :name,
      :start_time,
      :length_in_minutes,
      :max_number_of_registrations,
      :state
    )
  end
end
