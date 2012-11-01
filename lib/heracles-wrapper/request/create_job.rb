require 'uri'
require 'json'

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

if __FILE__ == $0
  gem 'rest-client'
  gem 'webmock'
  gem 'minitest'
  gem 'minitest-matchers'
  gem 'debugger'
  require 'minitest/autorun'
  require 'rest-client'
  require 'webmock'
  require 'webmock/minitest'


  describe 'Heracles::Wrapper::Request::CreateJob' do
    require 'webmock/minitest'

    before(:all) do
      ::WebMock.disable_net_connect!
    end
    after(:all) do
      ::WebMock.allow_net_connect!
    end

    subject { Heracles::Wrapper::Request::CreateJob.new(*args) }
    let(:expected_api_key) { '12345678901234567890123456789012' }
    let(:expected_workflow_name) { 'RabbitWarren' }
    let(:expected_parent_job_id) { nil }
    let(:args) {
      [
        expected_api_key,
        expected_workflow_name,
        expected_parent_job_id,
        options
      ]
    }
    let(:options) { {} }

    describe "#call" do
      let(:expected_job_id) { 123 }
      let(:expected_job_location) {
        File.join(subject.url.to_s, expected_job_id.to_s)
      }

      it 'makes remote call and waits for response' do
        stub_request(:post, subject.url.to_s).
        to_return(
          {
            body: %({"job_id" : "#{expected_job_id}"}),
            status: 201,
            headers: {
              content_type: 'application/json',
              location: expected_job_location
            }
          }
        )
        subject.call.code.must_equal 201
        subject.call.job_id.must_equal expected_job_id.to_i
        subject.call.location.must_equal expected_job_location
      end

      it 'handles timeout' do
        stub_request(:post, subject.url.to_s).to_timeout
        lambda {
          subject.call
        }.must_raise Heracles::Wrapper::RequestFailure
      end

      it 'handles redirection' do
        stub_request(:post, subject.url.to_s).to_return(status: 302)
        lambda {
          subject.call
        }.must_raise Heracles::Wrapper::RequestFailure
      end
    end

    it 'has a URL' do
      subject.url.must_be_kind_of URI
    end

    describe "#as_json" do
      describe 'bare metal' do
        it 'has #as_json' do
          subject.as_json.must_equal(
            {
              api_key: expected_api_key,
              workflow_name: expected_workflow_name,
              parameters: {}
            }
          )
        end
      end

      describe 'with parent_job_id' do
        let(:expected_parent_job_id) { '1234' }
        it 'has #as_json' do
          subject.as_json.must_equal(
            {
              api_key: expected_api_key,
              workflow_name: expected_workflow_name,
              parent_job_id: expected_parent_job_id,
              parameters: {}
            }
          )
        end
      end

      describe 'with additional parameters' do
        let(:expected_callback_url) { 'my callback_url' }
        let(:options) {
          { callback_url: expected_callback_url, system_number: '1234' }
        }
        it 'has #as_json' do
          subject.as_json.must_equal(
            {
              api_key: expected_api_key,
              workflow_name: expected_workflow_name,
              parameters:
              {
                callback_url: expected_callback_url,
                system_number: options[:system_number]
              }
            }
          )
        end
      end
    end
  end
end
