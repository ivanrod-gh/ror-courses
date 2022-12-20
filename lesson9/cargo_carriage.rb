# frozen_string_literal: true

require_relative 'carriage'

class CargoCarriage < Carriage
  @all = []

  @validations = superclass.instance_variable_get(:@validations)

  def initialize(volume)
    super(volume, 'cargo')
    self.class.superclass.all << self
  end
end
