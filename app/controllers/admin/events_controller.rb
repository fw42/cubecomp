class Admin::EventsController < AdminController
  before_action :set_event, only: [:edit, :update, :destroy]

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
    @days = current_competition.days.with_events
  end

  def print
    day_id = params[:day_id].presence || current_competition.days.first.id
    @day = current_competition.days.find(day_id)
    render 'liquid/_schedule', layout: 'admin/schedule', locals: { day: @day }
  end

  def import_day_form
    format_date = ->(date) { I18n.l(date, format: :schedule) }

    @from_options = from_options_for_import_day_form
      .map{ |name, day_id, date, count| [ "#{name}, #{format_date.call(date)} (#{count} events)", day_id ] }

    @to_options = current_competition.days.map do |day|
      [ "#{current_competition.name}, #{format_date.call(day.date)}", day.id ]
    end
  end

  def import_day
    @day_to = current_competition.days.find_by!(id: params[:to_day_id])
    @day_from = Day.find_by!(id: params[:from_day_id])

    @day_to.transaction do
      DayEventsImportService.new(@day_from, @day_to).replace!
    end

    redirect_to admin_competition_events_path(current_competition), notice: 'Events successfully imported.'

  rescue ActiveRecord::RecordInvalid => e
    redirect_to admin_competition_events_path(current_competition),
      flash: { error: e.record.errors.full_messages.join(', ') }
  end

  def new
    @event = current_competition.events.new
  end

  def edit
  end

  def create
    @event = current_competition.events.new(event_params)

    if @event.save
      redirect_to admin_competition_events_path(current_competition),
        notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
      redirect_to admin_competition_events_path(current_competition),
        notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to admin_competition_events_url(current_competition),
      notice: 'Event was successfully deleted.'
  end

  def destroy_day
    @events = current_competition.events.where(day_id: params[:day_id])
    @events.destroy_all
    redirect_to admin_competition_events_url(current_competition),
      notice: 'Events for the day were successfully deleted.'
  end

  private

  def set_event
    @event = current_competition.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(PERMITTED_PARAMS)
  end

  def from_options_for_import_day_form
    Competition
      .joins(days: :events)
      .where.not('competitions.id' => current_competition.id)
      .group('competitions.name, days.date')
      .order('competitions.name, days.date')
      .pluck('competitions.name, days.id, days.date, COUNT(events.id)')
  end
end
