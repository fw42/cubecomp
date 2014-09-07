module AdminHelper
  def help_tooltip(text)
    render 'tooltip', body: image_tag('help.png'), title: text
  end
end
