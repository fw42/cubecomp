class MenuItem
  attr_reader :label, :url, :css

  def self.parse(controller, items)
    items.map do |options|
      options = options.merge(current_controller_instance: controller)
      MenuItem.new(options)
    end
  end

  def initialize(options = {})
    @label = options[:label]
    @css = options[:css]
    @url = options[:url]
    @controller = Array(options[:controller])
    @actions = options[:actions]
    @current_controller_instance = options[:current_controller_instance]
  end

  def active?
    return false unless @controller.any? do |controller|
      @current_controller_instance.is_a?(controller)
    end

    return true unless @actions

    @actions.any? { |action| action == @current_controller_instance.action_name }
  end
end
