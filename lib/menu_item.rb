class MenuItem
  attr_reader :label, :url, :css

  def initialize(label:, controller:, url:, css:, current_controller_instance:)
    @label = label
    @css = css
    @url = url
    @controller = controller
    @current_controller_instance = current_controller_instance
  end

  def active?
    @current_controller_instance.is_a?(@controller)
  end
end
