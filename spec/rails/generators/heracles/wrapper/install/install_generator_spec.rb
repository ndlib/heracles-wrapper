gem 'rails'
require File.expand_path(
  File.join(
    '../../../../../../../',
    'lib/rails/generators/heracles/wrapper/install/install_generator'
  ), __FILE__
)
class Heracles::Wrapper::InstallGeneratorTest < Rails::Generators::TestCase
  tests Heracles::Wrapper::InstallGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination

  test 'generates config when api key is provided' do
    @api_key = 'generic-api-key'
    run_generator(%w(-k generic-api-key))
    assert_file 'config/initializers/heracles-wrapper.rb' do |config|
      assert_match('Heracles::Wrapper.configure do |config|', config)
      assert_match(
        "config.api_key = #{@api_key.inspect}",
        config
      )
    end

  end

  test 'does not generate config when api key is omitted' do
    @api_key = 'generic-api-key'
    run_generator
    assert_no_file 'config/initializers/heracles-wrapper.rb'
  end
end
