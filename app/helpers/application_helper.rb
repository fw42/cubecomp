module ApplicationHelper
  def page_title(page_title)
    content_for(:page_title) { page_title }
  end

  def page_title_with_image(page_title, image_url)
    content_for(:page_title) do
      image_tag(image_url) + " " + page_title
    end
  end
end
