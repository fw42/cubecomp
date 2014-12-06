class ViewDrop < Liquid::Drop
  def initialize(controller:, template:, locals: {})
    @controller = controller
    @template = template
    @locals = locals
  end

  def to_s
    @controller.render_to_string(
      template: "liquid/#{@template}",
      locals: @locals,
      layout: false
    )
  end
end
