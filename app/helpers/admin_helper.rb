module AdminHelper
  def submit_button(form, title = 'Save', options = {})
    options[:type] ||= 'submit'

    if form
      form.button title, options
    else
      button_tag title, options
    end
  end

  def back_button(link_target)
    link_to 'Back', link_target, { class: 'button' }
  end

  def form_section(title, &block)
    render layout: 'form_section', locals: { title: title }, &block
  end

  def text_editor(form, field, options = {})
    render 'text_editor', form: form, field: field, id: "#{form.object_name}_#{field}", options: options
  end

  def tooltip(link, text)
    str = <<-HTML
      <span class='with-tooltip'>
        <span class='with-tooltip' data-toggle="tooltip" data-placement="top" data-original-title="#{h(text)}">
          #{link.html_safe}
        </span>
      </span>
    HTML

    str.html_safe
  end

  def icon_image_tag(filename)
    image_tag(filename, width: 16, height: 16)
  end

  def help_tooltip(text)
    tooltip(icon_image_tag('help.png'), text)
  end

  def show_button(title, *link_args)
    tooltip(link_to(icon_image_tag('show.png'), *link_args), title)
  end

  def waiting_button(*link_args)
    tooltip(link_to(icon_image_tag('set_waiting.png'), *link_args), 'Put on waiting list')
  end

  def unset_waiting_button(*link_args)
    tooltip(link_to(icon_image_tag('unset_waiting.png'), *link_args), 'Remove from waiting list')
  end

  def edit_button(*link_args)
    tooltip(link_to(icon_image_tag('edit.png'), *link_args), 'Edit')
  end

  def delete_button(*link_args)
    tooltip(link_to(icon_image_tag('delete.png'), *link_args), 'Delete')
  end

  def options_for_minutes
    [*1..24].map do |i|
      minutes = 5 * i
      str = "#{minutes} minutes"

      if minutes % 30 == 0
        hours = minutes / 60.0
        str << ' (%.1f %s)' % [hours, 'hour'.pluralize(hours)]
      end

      [str, minutes]
    end
  end
end
