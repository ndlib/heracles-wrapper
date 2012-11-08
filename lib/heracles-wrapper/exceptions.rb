module Heracles
  module Wrapper
    class RequestFailure < RuntimeError
      attr_reader :code, :messages, :response
      def initialize(response)
        @code = response.respond_to?(:code) ? response.code : 500
        @messages = response.respond_to?(:body) ? response.body : ''
        @response = response
        super("code: #{@code}")
      end
    end
    class ConfigurationError < RuntimeError
    end
  end
end
