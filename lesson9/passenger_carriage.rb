# frozen_string_literal: true

require_relative 'carriage'

class PassengerCarriage < Carriage
  @all = []

  @validations = superclass.instance_variable_get(:@validations)

  def initialize(volume)
    super(volume, 'passenger')
    self.class.superclass.all << self
  end
end
