gem 'rest-client'
require 'rest-client'
module Heracles
  module Wrapper
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

  def as_json
    {
      api_key: @api_key,
      workflow_name: @workflow_name,
      parameters: @parameters
    }.tap {|hash|
      hash[:parent_job_id] = @parent_job_id if @parent_job_id
    }
  end

  def call
    RestClient
    # Need to accept a self-signed cert.
    # Hits a given URL
    # Syncrhonously waits for response.
  end
end

if __FILE__ == $0
  require 'minitest/autorun'
  describe 'Heracles::Wrapper::Request::CreateJob' do
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
