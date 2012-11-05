require File.expand_path("../heracles-wrapper", File.dirname(__FILE__))
require 'ostruct'
module Heracles::Wrapper
  module TestHelper
    RESPONSE_JOB_ID = 1234.freeze
    RESPONSE_CODE = 201.freeze

    # Presently I'm leaning on the implementation details of :create_job
    # for returning the API.
    def with_heracles_service_stub(service_name, response = {})
      old_service = Heracles::Wrapper.send("#{service_name}_service")

      response[:job_id] ||= RESPONSE_JOB_ID
      response[:location] ||= "http://localhost:8080/jobs/#{response[:job_id]}"
      response[:code] ||= RESPONSE_CODE
      response[:messages] ||= []

      Heracles::Wrapper.send(
        "#{service_name}_service=",
        lambda { |config,options|
          OpenStruct.new(
            :config => config,
            :workflow_name => options.fetch(:workflow_name),
            :parent_job_id => options.fetch(:parent_job_id, nil),
            :parameters => options.fetch(:parameters, {}),
            :call => OpenStruct.new(response)
          )
        }
      )
      yield
    ensure
      Heracles::Wrapper.send("#{service_name}_service=", old_service)
    end
  end
end
