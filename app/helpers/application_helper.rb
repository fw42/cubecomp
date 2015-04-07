module ApplicationHelper
  def page_title(page_title)
    content_for(:page_title) { page_title }
  end

  def page_title_with_image(page_title, image_tag)
    content_for(:page_title_image) { image_tag }
    content_for(:page_title) { " " + page_title }
  end
end
