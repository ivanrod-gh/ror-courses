require_relative 'carriage'

class СargoСarriage < Carriage
  VOLUME_SIZE_MIN = 50.0
  VOLUME_SIZE_MAX = 100.0

  def initialize(volume_size)
    @volume_size = volume_size
    @volume_occupied_size = 0
    super('cargo')
  end

  def occupy_volume(volume)
    occupy_volume!(volume)
  end

  def volume_occupied_size
    @volume_occupied_size
  end

  def volume_realesed_size
    @volume_size - @volume_occupied_size
  end

  protected

  def validate!
    raise "Неверный объем вагона!" if @volume_size < VOLUME_SIZE_MIN || @volume_size > VOLUME_SIZE_MAX
    true
  end

  def occupy_volume!(volume)
    @volume_occupied_size += volume
  end
end