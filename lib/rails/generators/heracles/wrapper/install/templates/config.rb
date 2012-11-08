Heracles::Wrapper.configure do |config|
  if Rails.env.production?
    config.api_key = "<%= options[:api_key] %>"
  elsif Rails.env.preproduction?
    config.api_key = "change-me-as-needed"
    config.heracles_base_url = 'https://heraclespprd.library.nd.edu'
  else
    config.api_key = "change-me-as-needed"
    config.heracles_base_url = 'http://localhost:8765'
  end
end
