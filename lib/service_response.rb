
class ServiceResponse

  def self.success(reason)
    new(:success, reason)
  end

  def self.failure(reason)
    new(:failure, reason)
  end

  def initialize(status, reason)
    @status = status
    @reason = reason
  end

  SUCCESS = success("Unspecified Reason").freeze
  FAILURE = failure("Unspecified Reason").freeze

  attr_reader :reason

  def success?
    @status == :success
  end

  def failure?
    @status == :failure
  end
end