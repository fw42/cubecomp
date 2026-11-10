# Liquid::Template.parse uses the default environment unless told otherwise
Liquid::Environment.default.error_mode = :strict

Rails.application.config.to_prepare do
  [
    Liquid::Filters::Url,
    Liquid::Filters::I18n,
    Liquid::Filters::String,
  ].each do |filter|
    Liquid::Environment.default.register_filter(filter)
  end
end
