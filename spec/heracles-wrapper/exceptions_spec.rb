require File.expand_path('../../../lib/heracles-wrapper/exceptions', __FILE__)
require 'minitest/autorun'
require 'ostruct'
describe Heracles::Wrapper::RequestFailure do
  describe 'well formed response' do
    subject { Heracles::Wrapper::RequestFailure.new(response) }
    let(:response) {
      OpenStruct.new(:code => expected_code, :body => expected_body)
    }
    let(:expected_code) { 123 }
    let(:expected_body) { "{\"hello\":\"world\"}" }
    it('has #code') { subject.code.must_equal expected_code }
    it('has #messages') { subject.messages.fetch('hello').must_equal "world" }
    it('has #response') { subject.response.must_equal response }
    it('has #to_s') { subject.to_s.must_equal "code: #{expected_code}" }
  end
  describe 'poorly formed response as per a timeout' do
    subject { Heracles::Wrapper::RequestFailure.new(response) }
    let(:response) { Object.new }
    let(:expected_code) { 500 }
    let(:expected_body) { '' }
    it('has #code') { subject.code.must_equal expected_code }
    it('has #messages') { subject.messages.must_equal({}) }
    it('has #response') { subject.response.must_equal response }
    it('has #to_s') { subject.to_s.must_equal "code: #{expected_code}" }
  end
end