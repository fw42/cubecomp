Liquid::Template.error_mode = :strict

filters = [
  ImageFilters,
  I18nFilters,
]

filters.each do |filter|
  Liquid::Template.register_filter(filter)
end
