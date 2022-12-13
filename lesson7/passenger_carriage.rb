require_relative 'carriage'

class PassengerСarriage < Carriage
  def initialize(volume)
    super(volume, 'passenger')
  end

  protected

  def validate!
    raise "Неверное количество мест в вагоне!" if @volume < VOLUME_MIN || @volume > VOLUME_MAX
    true
  end
end