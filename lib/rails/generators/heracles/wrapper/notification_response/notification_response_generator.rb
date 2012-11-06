require 'rails/generators'
module Heracles
  module Wrapper
    class NotificationResponseGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def create_model
        template(
          'notification_response.rb.erb',
          File.join('app/models/', "#{file_name}.rb")
        )
      end
      def create_spec
        template(
          'notification_response_spec.rb.erb',
          File.join('spec/models/',"#{file_name}_spec.rb")
        )
      end
    end
  end
end
