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

  describe "with_heracles_service_stub" do
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
    let(:input_parameters) {
      {
        :workflow_name => 'TacoBuilder',
        :parameters => {
          :hello => 'world'
        }
      }
    }
    def stub_live_http_request
      stub_request(
        :post,
        File.join(Heracles::Wrapper.config.heracles_base_url, 'jobs')
      ).
      to_return(
        {
          :body => %({"job_id" : "#{
                          Heracles::Wrapper::TestHelper::RESPONSE_JOB_ID
          }"}),
          :status => Heracles::Wrapper::TestHelper::RESPONSE_CODE,
          :headers => {
            :content_type => 'application/json',
            :location => Heracles::Wrapper::TestHelper::RESPONSE_LOCATION
          }
        }
      )
    end
    it 'should respond like other systems' do
      @stubbed_response = nil
      with_heracles_service_stub(:create_job) do
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
