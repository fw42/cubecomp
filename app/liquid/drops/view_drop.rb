class ViewDrop < Liquid::Drop
  def initialize(controller:, template:, locals: {})
    @controller = controller
    @template = template
    @locals = locals
  end

  def to_s
    @controller.render_to_string(
      partial: "liquid/#{@template}",
      assigns: @locals,
      layout: false,
      formats: [:html]
    )
  end
end
