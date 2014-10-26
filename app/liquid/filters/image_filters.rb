module ImageFilters
  def image_tag(filename)
    "<img src=\"#{image_url(filename)}\">"
  end

  def image_url(filename)
    theme_file = competition.theme_files.image_files.find_by!(filename: filename)
    theme_file.image.url
  end

  private

  def competition
    @context.registers[:competition]
  end
end
