class DayDrop < Liquid::Drop
  def initialize(day:, controller:)
    @controller = controller
    @day = day
  end

  def schedule
    @schedule ||= ViewDrop.new(
      template: 'schedule',
      locals: { day: @day },
      controller: @controller
    )
  end
end
