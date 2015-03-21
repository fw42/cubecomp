Liquid::Template.error_mode = :strict

filters = [
  Liquid::Filters::Url,
  Liquid::Filters::I18n,
  Liquid::Filters::String,
]

filters.each do |filter|
  Liquid::Template.register_filter(filter)
end
