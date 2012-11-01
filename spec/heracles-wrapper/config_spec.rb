require File.expand_path('../../../lib/heracles-wrapper/config', __FILE__)
require 'minitest/autorun'
describe 'Heracles::Wrapper::Config' do
  subject {
    Heracles::Wrapper::Config.new { |c|
      c.api_key = expected_api_key
    }
  }
  let(:expected_api_key) { '12345678901234567890123456789012'}
  it 'should initialize with a block' do
    subject.api_key.must_equal expected_api_key
  end

  it 'should have heracles base url' do
    subject.heracles_base_url.must_equal Heracles::Wrapper::HERACLES_BASE_URL
  end
end
