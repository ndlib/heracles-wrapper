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
        lambda { |config,workflow_name,parent_job_id,parameters|
          OpenStruct.new(
            :config => config,
            :workflow_name => workflow_name,
            :parent_job_id => parent_job_id,
            :parameters => parameters,
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