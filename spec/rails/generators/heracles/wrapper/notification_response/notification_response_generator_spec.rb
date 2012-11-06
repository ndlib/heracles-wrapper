gem 'rails'
require File.expand_path(
  File.join(
    '../../../../../../../lib/rails/generators/heracles/wrapper',
    '/notification_response/notification_response_generator'
  ), __FILE__
)
module Heracles::Wrapper
  class NotificationResponseGeneratorTest < Rails::Generators::TestCase
    tests Heracles::Wrapper::NotificationResponseGenerator
    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    test 'should generate with a name' do
      run_generator(%w(MonkeyPatch))
      assert_file 'app/models/monkey_patch.rb' do |file|
        assert_match(
          /^#{%(require 'heracles/wrapper/notification_response')}$/,
          file
        )
        assert_match(
          /^#{%(require 'delegate')}$/,
          file
        )
        assert_match(
          /^class\ MonkeyPatch\ \<\ DelegateClass\(Heracles::Wrapper::NotificationResponse\)$/,
          file
        )
        assert_method(:initialize, file)
      end
    end
  end
end
