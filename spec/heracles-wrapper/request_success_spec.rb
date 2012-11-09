require File.expand_path(
  '../../../lib/heracles-wrapper/request_success', __FILE__
)
require File.expand_path('../../../lib/heracles-wrapper/config', __FILE__)
require 'minitest/autorun'
require 'webmock/minitest'
require 'ostruct'
require 'json'

describe 'Heracles::Wrapper::RequestSuccess' do
  subject { Heracles::Wrapper::RequestSuccess.new(http_response) }
  let(:expected_job_id) { 1234 }
  let(:expected_errors) { %({"name" : "one message"}) }
  let(:expected_code) { 201 }
  let(:expected_location) { 'http://somewhere.over/the/rainbown' }
  describe 'without errors' do
    let(:http_response) {
      OpenStruct.new(
        :body => %(
          {
            "job": {
              "id": #{expected_job_id}
            }
          }
        ),
        :headers => { :location => expected_location },
        :code => expected_code
      ).tap { |obj|
        def obj.foo_bar; 'Baz'; end
      }
    }
    it 'has #errors' do
      subject.errors.must_equal({})
    end


  end
  describe 'with errors' do
    let(:http_response) {
      OpenStruct.new(
        :body => %(
          {
            "job": {
              "id": #{expected_job_id}
            },
            "errors": #{expected_errors}
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

    it 'has #errors' do
      subject.errors.must_equal JSON.parse(expected_errors)
    end

    it 'delegates everything else to the http_response' do
      subject.foo_bar.must_equal 'Baz'
    end
  end
end
