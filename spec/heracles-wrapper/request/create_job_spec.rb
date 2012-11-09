require File.expand_path(
  '../../../../lib/heracles-wrapper/request/create_job', __FILE__
)
require File.expand_path('../../../../lib/heracles-wrapper/config', __FILE__)
require 'minitest/autorun'
require 'webmock/minitest'

describe 'Heracles::Wrapper::Request::CreateJob' do
  require 'webmock/minitest'

  before(:all) do
    ::WebMock.disable_net_connect!
  end
  after(:all) do
    ::WebMock.allow_net_connect!
  end

  subject { Heracles::Wrapper::Request::CreateJob.new(config, options) }
  let(:config) {
    Heracles::Wrapper::Config.new {|c|
      c.api_key = expected_api_key
    }
  }
  let(:expected_api_key) { '12345678901234567890123456789012' }
  let(:expected_workflow_name) { 'RabbitWarren' }
  let(:expected_parent_job_id) { nil }
  let(:options) {
    {
      :workflow_name => expected_workflow_name,
      :parent_job_id => expected_parent_job_id,
    }
  }

  describe "#call" do
    let(:expected_job_id) { 123 }
    let(:expected_job_location) {
      File.join(subject.url.to_s, expected_job_id.to_s)
    }

    it 'makes remote call and waits for response' do
      stub_request(:post, subject.url.to_s).
      to_return(
        {
          :body => %({"job_id" : "#{expected_job_id}"}),
          :status => 201,
          :headers => {
            :content_type => 'application/json',
            :location => expected_job_location
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
      stub_request(:post, subject.url.to_s).to_return(:status => 302)
      lambda {
        subject.call
      }.must_raise Heracles::Wrapper::RequestFailure
    end

    it 'handles 404' do
      stub_request(:post, subject.url.to_s).to_return(:status => 404)
      lambda {
        subject.call
      }.must_raise Heracles::Wrapper::RequestFailure
    end

    it 'handles 401' do
      stub_request(:post, subject.url.to_s).to_return(:status => 401)
      lambda {
        subject.call
      }.must_raise Heracles::Wrapper::RequestFailure
    end

    it 'handles 500' do
      stub_request(:post, subject.url.to_s).to_return(:status => 500)
      lambda {
        subject.call
      }.must_raise Heracles::Wrapper::RequestFailure
    end
  end

  it 'has a #url' do
    subject.url.must_be_kind_of URI
  end

  it 'has #parameters' do
    subject.parameters.must_be_kind_of Hash
  end

  it 'has #config' do
    subject.must_respond_to :config
  end

  it 'has #parent_job_id' do
    subject.must_respond_to :parent_job_id
  end

  it 'has #workflow_name' do
    subject.must_respond_to :workflow_name
  end

  describe "#as_json" do
    describe 'bare metal' do
      it 'has #as_json' do
        subject.as_json.must_equal(
          {
            :api_key => expected_api_key,
            :job => {
              :workflow_name => expected_workflow_name,
              :parameters => {}
            }
          }
        )
      end
    end

    describe 'with parent_job_id' do
      let(:expected_parent_job_id) { '1234' }
      it 'has #as_json' do
        subject.as_json.must_equal(
          {
            :api_key => expected_api_key,
            :job => {
              :workflow_name => expected_workflow_name,
              :parent_job_id => expected_parent_job_id,
              :parameters => {}
            }
          }
        )
      end
    end

    describe 'with additional parameters' do
      let(:expected_callback_url) { 'my callback_url' }
      let(:options) {
        {
          :workflow_name => expected_workflow_name,
          :parent_job_id => expected_parent_job_id,
          :parameters => {
            :callback_url => expected_callback_url,
            :system_number => '1234'
          }
        }
      }
      it 'has #as_json' do
        subject.as_json.must_equal(
          {
            :api_key => expected_api_key,
            :job => {
              :workflow_name => expected_workflow_name,
              :parameters => options[:parameters]
            }
          }
        )
      end
    end
  end
end
