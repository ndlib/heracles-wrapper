require 'rails/generators'
class Heracles::Wrapper::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  class_option(
    :api_key,
    :aliases => "-k",
    :type => :string,
    :desc => "Your Heracles API key",
    :required => true
  )

  def install
    ensure_api_key_was_configured
    generate_config
  end

  private
  def ensure_api_key_was_configured
    if api_key_configured?
      puts "Already configured"
      exit
    end
  end

  def generate_config
    template 'config.rb', initializer_filename
  end

  def initializer_filename
    'config/initializers/heracles-wrapper.rb'
  end

  def api_key_configured?
    File.exists?(initializer_filename)
  end

end
