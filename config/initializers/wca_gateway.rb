DEPENDENCIES = {}

if Rails.application.config.wca_api_url
  DEPENDENCIES[:wca_gateway] = WcaGateway.new(Rails.application.config.wca_api_url)
end
