class BaseService
  attr_reader :errors
  attr_accessor :result

  def initialize
    @errors = {}
    @result = nil
  end

  def has_error?
    errors.present?
  end

  private

  def set_up_error(error)
    @errors[:base] = error.message

    self
  end

  attr_writer :errors
end
