require 'uri'
require 'json'
require 'rest-client'

module Heracles
  module Wrapper
    class RequestFailure < RuntimeError
    end
    module Request
    end
  end
end

class Heracles::Wrapper::Request::CreateJob
  def initialize(api_key, workflow_name, parent_job_id, parameters = {})
    @api_key = api_key
    @workflow_name = workflow_name
    @parent_job_id = parent_job_id
    @parameters = parameters.freeze
  end

  def url
    URI.parse("https://heracles.library.nd.edu/jobs")
  end

  def as_json
    {
      api_key: @api_key,
      workflow_name: @workflow_name,
      parameters: @parameters
    }.tap {|hash|
      hash[:parent_job_id] = @parent_job_id if @parent_job_id
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
          content_type: :json,
          accept: :json,
          verify_ssl: OpenSSL::SSL::VERIFY_NONE
        }
      )
    )
  rescue RestClient::Exception => e
    raise Heracles::Wrapper::RequestFailure.new(e)
  end
  protected
  def decorate_response(response)
    # This is dirty but it highlights the expected API.
    def response.job_id
      JSON.parse(body)['job_id'].to_i
    end

    def response.location
      headers.fetch(:location)
    end
    response
  end
end