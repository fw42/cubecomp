module AdminHelper
  def form_section(title, &block)
    render layout: 'form_section', locals: { title: title }, &block
  end

  def help_tooltip(text)
    render 'tooltip', body: image_tag('help.png'), title: text
  end

  def delete_button(text, *link_args)
    render 'tooltip', body: link_to(image_tag('delete.png'), *link_args), title: text
  end
end
