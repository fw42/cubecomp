Liquid::Template.error_mode = :strict

filters = [
  Liquid::Filters::Url,
  Liquid::Filters::I18n,
]

filters.each do |filter|
  Liquid::Template.register_filter(filter)
end
