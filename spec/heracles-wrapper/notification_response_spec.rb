require File.expand_path(
  '../../../lib/heracles-wrapper/notification_response', __FILE__
)
require 'minitest/autorun'

describe Heracles::Wrapper::NotificationResponse do
  subject { Heracles::Wrapper::NotificationResponse.new(params) }
  let(:expected_job_id) { 1234 }
  let(:params) {
    {
      :job_id => expected_job_id
    }
  }
  it 'should have #job_id' do
    subject.job_id.must_equal expected_job_id
  end
  it 'should have #one_time_key' do
    subject.must_respond_to :one_time_key
  end
end
