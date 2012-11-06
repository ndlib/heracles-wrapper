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
    end
  end
end
