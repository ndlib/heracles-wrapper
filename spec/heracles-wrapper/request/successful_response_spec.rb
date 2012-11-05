require File.expand_path(
  '../../../../lib/heracles-wrapper/request/successful_response', __FILE__
)
require File.expand_path('../../../../lib/heracles-wrapper/config', __FILE__)
require 'minitest/autorun'
require 'webmock/minitest'
require 'ostruct'

describe 'Heracles::Wrapper::Request::SuccessfulResponse' do
  subject { Heracles::Wrapper::Request::SuccessfulResponse.new(http_response) }
  let(:expected_job_id) { 1234 }
  let(:expected_location) { 'http://somewhere.over/the/rainbown' }
  let(:http_response) {
    OpenStruct.new(
      :body => %({"job_id": #{expected_job_id}}),
      :headers => { location: expected_location }
    )
  }

  it 'has #job_id' do
    subject.job_id.must_equal expected_job_id
  end

  it 'has #location' do
    subject.location.must_equal expected_location
  end
end