module AdminHelper
  def submit_button(form)
    form.button 'Save', type: 'submit'
  end

  def cancel_button(link_target)
    link_to 'Cancel', link_target, { class: 'button' }
  end

  def form_section(title, &block)
    render layout: 'form_section', locals: { title: title }, &block
  end

  def text_editor(form, field)
    render 'text_editor', form: form, field: field, id: "#{form.object_name}_#{field}"
  end

  def tooltip(link, text)
    render 'tooltip', body: link, title: text
  end

  def help_tooltip(text)
    tooltip(image_tag('help.png'), text)
  end

  def delete_button(text, *link_args)
    render 'tooltip', body: link_to(image_tag('delete.png'), *link_args), title: text
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
