require File.expand_path("heracles-wrapper/version", File.dirname(__FILE__))
require File.expand_path("heracles-wrapper/config", File.dirname(__FILE__))
require File.expand_path("heracles-wrapper/request/create_job", File.dirname(__FILE__))

module Heracles
  module Wrapper
    module_function
    def configure(&block)
      @config = Config.new(&block)
    end
    def config
      @config
    end

    def build_request_for_create_job(options = {})
      workflow_name = options.fetch(:workflow_name)
      parent_job_id = options.fetch(:parent_job_id, nil)
      parameters = options.fetch(:parameters, {})
      Heracles::Wrapper::Request::CreateJob.new(
        config, workflow_name, parent_job_id, parameters
      )
    end
  end
end