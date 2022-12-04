require_relative 'carriage'

class PassengerСarriage < Carriage
  def initialize
    @type = 'passenger'
  end
end