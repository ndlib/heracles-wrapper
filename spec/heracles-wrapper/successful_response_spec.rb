require File.expand_path(
  '../../../lib/heracles-wrapper/successful_response', __FILE__
)
require File.expand_path('../../../lib/heracles-wrapper/config', __FILE__)
require 'minitest/autorun'
require 'webmock/minitest'
require 'ostruct'

describe 'Heracles::Wrapper::SuccessfulResponse' do
  subject { Heracles::Wrapper::SuccessfulResponse.new(http_response) }
  let(:expected_job_id) { 1234 }
  let(:expected_messages) { ['one message'] }
  let(:expected_code) { 201 }
  let(:expected_location) { 'http://somewhere.over/the/rainbown' }
  let(:http_response) {
    OpenStruct.new(
      :body => %(
        {
          "job_id": #{expected_job_id},
          "messages": #{expected_messages.inspect}
        }
      ),
      :headers => { :location => expected_location },
      :code => expected_code
    ).tap { |obj|
      def obj.foo_bar; 'Baz'; end
    }
  }

  it 'has #code' do
    subject.code.must_equal expected_code
  end

  it 'has #job_id' do
    subject.job_id.must_equal expected_job_id
  end

  it 'has #location' do
    subject.location.must_equal expected_location
  end

  it 'has #messages' do
    subject.messages.must_equal expected_messages
  end

  it 'delegates everything else to the http_response' do
    subject.foo_bar.must_equal 'Baz'
  end
end
