class MenuItem
  attr_reader :label, :url, :css

  def self.parse(controller, items)
    items.map do |options|
      options = options.merge(current_controller_instance: controller)
      MenuItem.new(**options)
    end
  end

  def initialize(label:, controller:, url:, css:, current_controller_instance:, actions: nil)
    @label = label
    @css = css
    @url = url
    @controller = Array(controller)
    @actions = actions
    @current_controller_instance = current_controller_instance
  end

  def active?
    return false unless @controller.any? do |controller|
      @current_controller_instance.is_a?(controller)
    end

    if @actions
      @actions.any? { |action| action == @current_controller_instance.action_name }
    else
      true
    end
  end
end
