filters = [
  ImageFilters
]

filters.each do |filter|
  Liquid::Template.register_filter(filter)
end
