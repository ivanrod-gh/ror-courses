require_relative 'carriage'

class СargoСarriage < Carriage
  def initialize
    super
    @type = 'cargo'
  end
end