require File.expand_path("../exceptions", File.dirname(__FILE__))
require 'json'

module Heracles
  module Wrapper
    module Request
    end
  end
end

class Heracles::Wrapper::Request::SuccessfulResponse
  attr_reader :job_id
  def initialize(http_response)
    @job_id = JSON.parse(http_response.body).fetch('job_id').to_i
  end
end