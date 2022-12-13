require_relative 'carriage'

class СargoСarriage < Carriage
  def initialize(volume)
    super(volume, 'cargo')
  end

  protected

  def validate!
    raise "Неверный объем вагона!" if @volume < VOLUME_MIN || @volume > VOLUME_MAX
    true
  end
end