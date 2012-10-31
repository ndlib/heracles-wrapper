module Heracles
  module Wrapper
  end
end

class Heracles::Wrapper::Response
  def initialize(params)
    @params = params
  end
  def request_parameters
    @params.fetch(:request)
  end
end

if __FILE__ == $0
  require 'minitest/autorun'
  describe 'Heracles::Wrapper::Response' do
    subject { Heracles::Wrapper::Response.new(params) }
    let(:expected_request_parameters) { { callback_url: 'http://google.com' }}
    let(:params) { {request: expected_request_parameters } }
    it 'should have #request_parameters' do
      subject.request_parameters.must_equal expected_request_parameters
    end
  end
end
