require File.expand_path(
  '../../../lib/heracles-wrapper/notification_response', __FILE__
)
require 'minitest/autorun'

describe Heracles::Wrapper::NotificationResponse do
  subject { Heracles::Wrapper::NotificationResponse.new(params) }
  describe 'well formed response' do
    let(:expected_job_status) { 'ok'}
    let(:expected_job_id) { '1234' }
    let(:params) {
      {
        :job_id => expected_job_id,
        :job_status => expected_job_status,
        :notification_payload => {
          :hello => { :world => [{:foo => 1},{:foo => 2},{:bar => 3}]}
        }
      }
    }

    it 'should extract methods based on keys' do
      subject.must_respond_to :fetch
      subject.fetch(:hello).must_equal(
        params.fetch(:notification_payload).fetch(:hello)
      )
    end

    it 'should have #job_status' do
      subject.job_status.must_equal expected_job_status.to_sym
    end
    it 'should have #job_id' do
      subject.job_id.must_equal expected_job_id.to_i
    end

    it 'should have #one_time_notification_key' do
      subject.must_respond_to :one_time_notification_key
    end

    it 'should have #notification_payload' do
      subject.must_respond_to :notification_payload
    end
  end

  describe 'poorly formed response' do
    let(:params) { {} }

    it 'should raise error' do
      lambda { subject }.must_raise ArgumentError
    end

  end
end

describe Heracles::Wrapper do

  require 'delegate'
  class DelegateResponse < DelegateClass(Heracles::Wrapper::NotificationResponse)
    attr_reader :pid
    def initialize(params)
      super(Heracles::Wrapper::NotificationResponse.new(params))
      @pid = fetch(:pid)
    end
  end

  describe DelegateResponse do
    subject {DelegateResponse.new(params)}
    let(:params) {
      {
        :job_id => '1234',
        :job_status => 'ok',
        :notification_payload => {
          :pid => 'abc'
        }
      }
    }
    describe 'well formed' do
      it 'has a job_id and includes locally defined methods' do
        subject.job_id.must_equal 1234
        subject.job_status.must_equal :ok
        subject.pid.must_equal 'abc'
      end
    end

    describe 'poorly formed' do
      let(:params) { {:notification_payload => {:pid => 'abc'}} }
      it 'fails as an underlying pre-condition is not met' do
        lambda {
          subject
        }.must_raise ArgumentError
      end
    end
  end
end
