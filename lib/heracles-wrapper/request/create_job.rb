require 'uri'
require 'json'
require 'rest-client'
require File.expand_path("../exceptions", File.dirname(__FILE__))
require File.expand_path("../request_success", File.dirname(__FILE__))


module Heracles
  module Wrapper
    module Request
    end
  end
end

class Heracles::Wrapper::Request::CreateJob
  attr_reader(
    :config,
    :workflow_name,
    :parent_job_id,
    :parameters,
    :url
  )
  def initialize(config, options = {})
    @config = config
    @workflow_name = options.fetch(:workflow_name)
    @parent_job_id = options.fetch(:parent_job_id, nil)
    @parameters = options.fetch(:parameters, {})
    @url = URI.parse(File.join(config.heracles_base_url, 'jobs'))
  end

  def as_json
    {
      :api_key => config.api_key,
      :job => {
        :workflow_name => workflow_name,
        :parameters => parameters
      }
    }.tap {|hash|
      hash[:job][:parent_job_id] = parent_job_id if parent_job_id
    }
  end

  # Need to accept a self-signed cert.
  # Hits a given URL
  # Syncrhonously waits for response.
  def call
    decorate_response(
      RestClient.post(
        url.to_s,
        as_json,
        {
          :content_type => :json,
          :accept => :json,
          :verify_ssl => OpenSSL::SSL::VERIFY_NONE
        }
      )
    )
  rescue RestClient::Exception => e
    raise Heracles::Wrapper::RequestFailure.new(e.response)
  end
  protected
  def decorate_response(response)
    Heracles::Wrapper::RequestSuccess.new(response)
  end
end
