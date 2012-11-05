require File.expand_path("exceptions", File.dirname(__FILE__))
require 'rest-client'
require 'json'
require 'delegate'

module Heracles
  module Wrapper
    class SuccessfulResponse < DelegateClass(RestClient::Response)
      attr_reader(
        :job_id,
        :location,
        :messages,
        :code
      )
      def initialize(http_response)
        super(http_response)
        @json = JSON.parse(http_response.body)
        @job_id = @json.fetch('job_id').to_i
        @messages = @json.fetch('messages',[]).to_a
        @location = http_response.headers.fetch(:location)
        @code = http_response.code
      end
    end
  end
end
