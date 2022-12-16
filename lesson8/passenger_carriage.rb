# frozen_string_literal: true

require_relative 'carriage'

class PassengerCarriage < Carriage
  @all = []

  def initialize(volume)
    super(volume, 'passenger')
    self.class.superclass.all << self
  end

  protected

  def validate!
    raise "Неверное количество мест в вагоне!" if @volume < VOLUME_MIN || @volume > VOLUME_MAX

    true
  end
end
