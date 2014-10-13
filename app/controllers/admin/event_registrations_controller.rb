class Admin::EventRegistrationsController < AdminController
  before_action :set_registration, only: [:destroy, :set_waiting]

  def index
    @event = current_competition.events.find(params[:event_id])
    @registrations = @event.registrations.includes(:competitor)
  end

  def waiting
    @registrations = current_competition.event_registrations
      .where(waiting: true)
      .includes(:competitor)
      .includes(:event)
      .group_by(&:event)
  end

  def remove_all_waiting
    EventRegistration.transaction do
      current_competition.event_registrations.where(waiting: true).each(&:destroy!)
    end

    redirect_to admin_competition_events_path(current_competition),
      notice: 'Removed competitors from all waiting lists.'
  end

  def set_waiting
    @registration.update_attribute(:waiting, params[:waiting] == 'true')
    redirect_to admin_competition_event_event_registrations_path(current_competition, params[:event_id]),
      notice: 'Registration was marked as waiting.'
  end

  def destroy
    @registration.destroy
    redirect_to admin_competition_event_event_registrations_path(current_competition, params[:event_id]),
      notice: 'Registration was successfully deleted.'
  end

  private

  def set_registration
    @registration = current_competition.event_registrations.find_by!(event_id: params[:event_id], id: params[:id])
  end
end
