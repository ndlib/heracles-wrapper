require 'method_decorators'
require 'method_decorators/decorators/precondition'

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
    params.has_key?(:job_id) &&
    params.has_key?(:notification_payload) &&
    params[:notification_payload].respond_to?(:to_hash)
  }
  def initialize(params)
    @notification_payload = params.fetch(:notification_payload).to_hash
    @job_id = params.fetch(:job_id).to_i
    @one_time_notification_key = params.fetch(:one_time_notification_key, nil)
  end

  def method_missing(method_name, *args, &block)
    super
  rescue NoMethodError
    @notification_payload.send(method_name, *args, &block)
  end

  def respond_to?(method_name)
    super || @notification_payload.respond_to?(method_name)
  end
end
