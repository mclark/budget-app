
class ServiceResponse

  def initialize(status, reason)
    @status = status
    @reason = reason
  end

  SUCCESS = new(:success, "Unspecified Reason").freeze
  FAILURE = new(:failure, "Unspecified Reason").freeze

  attr_reader :reason

  def success?
    @status == :success
  end

  def failure?
    @status == :failure
  end
end