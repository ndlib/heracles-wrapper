require File.expand_path("heracles-wrapper/version", File.dirname(__FILE__))
require File.expand_path("heracles-wrapper/config", File.dirname(__FILE__))

module Heracles
  module Wrapper
    module_function
    def configure(&block)
      @config = Config.new(&block)
    end
    def config
      @config
    end
  end
end

if __FILE__ == $0
  require 'minitest/autorun'
  describe 'Heracles::Wrapper' do
    subject { Heracles::Wrapper.config }
    let(:expected_api_key) { '12345678901234567890123456789012'}
    it 'should initialize with a block' do
      Heracles::Wrapper.configure do |c|
        c.api_key = expected_api_key
      end

      subject.api_key.must_equal expected_api_key
    end
  end
end
