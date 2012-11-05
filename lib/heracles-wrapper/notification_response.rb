module Heracles
  module Wrapper
  end
end

class Heracles::Wrapper::NotificationResponse
  attr_reader(
    :job_id,
    :one_time_key
  )
  def initialize(params)
    @job_id = params.fetch(:job_id).to_i
    @one_time_key = params.fetch(:one_time_key, nil)
  end
end