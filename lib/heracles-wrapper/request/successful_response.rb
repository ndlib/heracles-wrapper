require File.expand_path("../exceptions", File.dirname(__FILE__))
require 'rest-client'
require 'json'
require 'delegate'

module Heracles
  module Wrapper
    module Request
      class SuccessfulResponse < DelegateClass(RestClient::Response)
        attr_reader(
          :job_id,
          :location,
          :code
        )
        def initialize(http_response)
          super(http_response)
          @job_id = JSON.parse(http_response.body).fetch('job_id').to_i
          @location = http_response.headers.fetch(:location)
          @code = http_response.code
        end
      end
    end
  end
end