require File.expand_path('../../../lib/heracles-wrapper/test_helper', __FILE__)
require 'minitest/autorun'
require 'webmock/minitest'

describe Heracles::Wrapper::TestHelper do
  include Heracles::Wrapper::TestHelper
  require 'webmock/minitest'

  before(:all) do
    Heracles::Wrapper.configure { |c| c.api_key = 1234 }
    ::WebMock.disable_net_connect!
  end
  after(:all) do
    Heracles::Wrapper.clear_config!
    ::WebMock.allow_net_connect!
  end

  let(:input_parameters) {
    {
      :workflow_name => 'TacoBuilder',
      :parameters => {
        :hello => 'world'
      }
    }
  }

  describe '#with_heracles_service_failure_stub' do
    let(:expected_message) {'No Soup For You'}
    it 'should require expected message' do
      with_heracles_service_failure_stub(:create_job, [expected_message]) do
        caller = Heracles::Wrapper.service(:create_job, input_parameters)
        lambda {
          value = caller.call
        }.must_raise(Heracles::Wrapper::RequestFailure, /#{expected_message}/)
      end
    end
  end

  describe "#with_heracles_service_stub" do
    it 'should return an object that adheres to request_success' do
      with_heracles_service_stub(:create_job) do
        @response = Heracles::Wrapper.service(
          :create_job, input_parameters
        ).call
        @response.job_id.must_be_kind_of Fixnum
        @response.messages.must_be_kind_of Array
        @response.code.must_be_kind_of Fixnum
        @response.location.must_be_kind_of String
      end
    end

    it 'should be non destructive to the caller' do
      @original_create_job_service = Heracles::Wrapper.create_job_service

      with_heracles_service_stub(:create_job) do
        @original_create_job_service.wont_be_same_as(
          Heracles::Wrapper.create_job_service
        )
      end

      Heracles::Wrapper.create_job_service.must_equal(
        @original_create_job_service
      )
    end
    let(:expected_job_id) { 1234 }
    let(:expected_code) { 201 }
    let(:expected_location) { "http://somewhere/jobs/#{expected_job_id}"}

    def stub_live_http_request
      stub_request(
        :post,
        File.join(Heracles::Wrapper.config.heracles_base_url, 'jobs')
      ).
      to_return(
        {
          :body => %({"job_id" : "#{expected_job_id}"}),
          :status => expected_code,
          :headers => {
            :content_type => 'application/json',
            :location => expected_location
          }
        }
      )
    end
    let(:expected_response) {
      {
        :job_id => expected_job_id,
        :code => expected_code,
        :location => expected_location
      }
    }
    it 'should respond like other systems' do
      @stubbed_response = nil
      with_heracles_service_stub(:create_job, expected_response) do
        @stubbed_response = Heracles::Wrapper.service(
          :create_job, input_parameters
        )
      end

      stub_live_http_request
      @full_response = Heracles::Wrapper.service(
        :create_job, input_parameters
      )

      @stubbed_response.config.must_equal @full_response.config
      @stubbed_response.workflow_name.must_equal @full_response.workflow_name
      @stubbed_response.parent_job_id.must_equal @full_response.parent_job_id
      @stubbed_response.parameters.must_equal @full_response.parameters

      @stubbed_response.call.job_id.must_equal @full_response.call.job_id

    end
  end
end
