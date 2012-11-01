require File.expand_path('../../lib/heracles-wrapper', __FILE__)
require 'minitest/autorun'
describe 'Heracles::Wrapper' do
  subject { Heracles::Wrapper }
  before(:each) do
    Heracles::Wrapper.clear_config!
  end
  before(:each) do
    Heracles::Wrapper.clear_config!
  end
  describe 'improperly configured' do
    it "should raise exception on .config if it wasn't set" do
      lambda { subject.config }.must_raise(
        Heracles::Wrapper::ConfigurationError,
        /config not set/
      )
    end
    it "should raise exception on .config if API Key is nil" do
      subject.configure {|c| c.api_key = nil }
      lambda { subject.config }.must_raise(
        Heracles::Wrapper::ConfigurationError,
        /api_key is invalid/
      )
    end
  end
  describe 'properly configured' do
    before(:each) do
      Heracles::Wrapper.configure do |c|
        c.api_key = expected_api_key
      end
    end
    let(:expected_api_key) { '12345678901234567890123456789012'}
    it 'has .config' do
      subject.config.must_be_kind_of Heracles::Wrapper::Config
    end

    let(:expected_workflow_name) { 'MyWorkflowName' }
    let(:expected_request_parameters) { { hello: 'World' } }
    it 'has .build_request_for_create_job that responds to call' do
      request = subject.build_request_for_create_job(
        workflow_name: expected_workflow_name,
        parameters: expected_request_parameters
      )
      request.parent_job_id.must_equal nil
      request.workflow_name.must_equal expected_workflow_name
      request.parameters.must_equal expected_request_parameters
      request.must_respond_to :call
    end
  end
end
