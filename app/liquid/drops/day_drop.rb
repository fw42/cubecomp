class DayDrop < Liquid::Drop
  def initialize(day:, controller:)
    @controller = controller
    @day = day
  end

  delegate :date, :entrance_fee_competitors, :entrance_fee_guests, to: :@day

  def schedule
    @schedule ||= ViewDrop.new(
      template: 'schedule',
      locals: { day: @day },
      controller: @controller
    )
  end
end
