require 'json'
module Heracles
  module Wrapper
    class RequestFailure < RuntimeError
      attr_reader :code, :messages, :response
      def initialize(response)
        @code = response.respond_to?(:code) ? response.code : 500
        begin
          @messages = response.respond_to?(:body) ? JSON.parse(response.body) : {}
        rescue JSON::ParserError
          @messages = {"errors" => "Not JSON format; See response.body"}
        end
        @response = response
        super("code: #{@code}")
      end
    end
    class ConfigurationError < RuntimeError
    end
  end
end
