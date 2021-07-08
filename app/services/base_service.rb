class BaseService
  attr_reader :errors
  attr_accessor :result

  def initialize
    @errors = {}
    @result = nil
  end

  private

  attr_writer :errors
end
