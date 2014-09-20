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

  def help_tooltip(text)
    render 'tooltip', body: image_tag('help.png'), title: text
  end

  def delete_button(text, *link_args)
    render 'tooltip', body: link_to(image_tag('delete.png'), *link_args), title: text
  end

  def options_for_minutes
    [*1..24].map{ |i|
      minutes = 5 * i
      str = "#{minutes} minutes"

      if minutes % 30 == 0
        hours = minutes / 60.0
        str << " (%.1f %s)" % [ hours, "hour".pluralize(hours) ]
      end

      [ str, minutes ]
    }
  end
end
