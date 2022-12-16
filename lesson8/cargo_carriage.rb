# frozen_string_literal: true

require_relative 'carriage'

class CargoCarriage < Carriage
  @all = []

  def initialize(volume)
    super(volume, 'cargo')
    self.class.superclass.all << self
  end

  protected

  def validate!
    raise "Неверный объем вагона!" if @volume < VOLUME_MIN || @volume > VOLUME_MAX

    true
  end
end
