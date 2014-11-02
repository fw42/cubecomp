class EventRegistrationDrop < Liquid::Drop
  def initialize(registration)
    @registration = registration
  end

  def waiting
    @registration.waiting?
  end

  def day
    @registration.event.day.date
  end

  def name
    @registration.event.name
  end
end
