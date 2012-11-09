require 'json'
module Heracles
  module Wrapper
    class RequestFailure < RuntimeError
      attr_reader :code, :errors, :response
      def initialize(response)
        @code = response.respond_to?(:code) ? response.code : 500
        begin
          @errors = response.respond_to?(:body) ?
            JSON.parse(response.body).fetch('errors',{}) :
            {}
        rescue JSON::ParserError
          @errors = {"errors" => "Not JSON format; See response.body"}
        end
        @response = response
        super("code: #{@code}")
      end
    end
    class ConfigurationError < RuntimeError
    end
  end
end
