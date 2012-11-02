require File.expand_path("heracles-wrapper/version", File.dirname(__FILE__))
require File.expand_path("heracles-wrapper/config", File.dirname(__FILE__))
require File.expand_path("heracles-wrapper/exceptions", File.dirname(__FILE__))
require File.expand_path("heracles-wrapper/request/create_job", File.dirname(__FILE__))
require 'morphine'
module Heracles
  module Wrapper
    module_function
    def configure(&block)
      @config = Config.new(&block)
    end

    def config
      if @config.nil?
        raise ConfigurationError.new("#{self}.config not set")
      end
      if @config.api_key.nil?
        raise ConfigurationError.new("#{self}.config.api_key is invalid")
      end
      @config
    end

    def clear_config!
      @config = nil
    end

    def build_request_for_create_job(options = {})
      create_job_service.call(config,options)
    end
    class << self
      include Morphine
      private
      register :create_job_service do
        Heracles::Wrapper::Request::CreateJob.method(:new)
      end
    end
  end
end
