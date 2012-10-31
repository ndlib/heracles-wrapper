module Heracles
  module Wrapper
  end
end
class Heracles::Wrapper::Request
  attr_reader :callback_url
  attr_reader :attributes

  def initialize(callback_url, attributes = {})
    @callback_url = callback_url.freeze
    @attributes = attributes.freeze
  end

  def as_json
    returning_value = {}
    returning_value[:request] = attributes.merge(
      { callback_url: callback_url }
    )
    returning_value
  end

  def call
  end
end

if __FILE__ == $0
  require 'minitest/autorun'
  describe 'Heracles::Wrapper::Request' do
    subject { Heracles::Wrapper::Request.new(*args) }
    let(:expected_callback_url) { 'my callback_url' }
    let(:args) { [expected_callback_url, options] }
    let(:options) { {} }

    describe 'bare metal' do
      it 'has #as_json' do
        subject.as_json.must_equal(
          {
            request:
            {
              callback_url: expected_callback_url
            }
          }
        )
      end
    end

    describe 'with additional attributes' do
      let(:options) { { system_number: '1234' } }
      it 'has #as_json' do
        subject.as_json.must_equal(
          {
            request:
            {
              callback_url: expected_callback_url,
              system_number: options[:system_number]
            }
          }
        )
      end
    end

  end
end
