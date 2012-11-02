require File.expand_path("../heracles-wrapper", File.dirname(__FILE__))
require 'ostruct'
module Heracles
  module Wrapper
    module TestHelper
      RESPONSE_JOB_ID = 1234.freeze
      RESPONSE_CODE = 201.freeze
      RESPONSE_LOCATION = "http://localhost:8080/jobs/#{RESPONSE_JOB_ID}".freeze
      def with_stub_for_build_request_for_create_job
        old_service = Heracles::Wrapper.create_job_service
        Heracles::Wrapper.create_job_service =
        lambda { |config,options|
          OpenStruct.new(
            :config => config,
            :workflow_name => options.fetch(:workflow_name),
            :parent_job_id => options.fetch(:parent_job_id, nil),
            :parameters => options.fetch(:parameters, {}),
            :call => OpenStruct.new(
              :code => RESPONSE_CODE,
              :job_id => RESPONSE_JOB_ID,
              :location => RESPONSE_LOCATION
            )
          )
        }
        yield
      ensure
        Heracles::Wrapper.create_job_service = old_service
      end
    end
  end
end