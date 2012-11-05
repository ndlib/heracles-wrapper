require 'method_decorators'
require 'method_decorators/decorators/precondition'
require File.expand_path("exceptions", File.dirname(__FILE__))
module Heracles
  module Wrapper
  end
end

class Heracles::Wrapper::NotificationResponse
  extend MethodDecorators
  attr_reader(
    :job_id,
    :notification_payload,
    :one_time_notification_key
  )
  +Precondition.new { |params|
    params.has_key?(:job_id) && params.has_key?(:notification_payload)
  }
  def initialize(params)
    @job_id = params.fetch(:job_id).to_i
    @notification_payload = params.fetch(:notification_payload)
    @one_time_key = params.fetch(:one_time_key, nil)
  end
end
