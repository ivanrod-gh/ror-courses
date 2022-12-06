require_relative 'carriage'

class PassengerСarriage < Carriage
  def initialize
    super
    @type = 'passenger'
  end
end