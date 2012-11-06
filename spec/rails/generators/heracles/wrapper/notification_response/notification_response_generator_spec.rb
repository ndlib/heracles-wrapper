gem 'rails'
TO_GEM_ROOT = "../../../../../../../"
require File.expand_path(
  File.join(
    TO_GEM_ROOT, 'lib/rails/generators/heracles/wrapper',
    '/notification_response/notification_response_generator'
  ), __FILE__
)
module Heracles::Wrapper
  class NotificationResponseGeneratorTest < Rails::Generators::TestCase
    tests Heracles::Wrapper::NotificationResponseGenerator
    destination(
      File.expand_path(File.join(TO_GEM_ROOT,"tmp", File.dirname(__FILE__)))
    )
    setup :prepare_destination

    test 'should generate model with a name' do
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

    test 'should generate spec with a name' do
      run_generator(%w(MonkeyPatch))
      assert_file 'spec/models/monkey_patch_spec.rb' do |file|
        assert_match(/^require 'spec_helper'/, file)
        assert_match(/^describe MonkeyPatch do$/, file)
      end
    end
  end
end
